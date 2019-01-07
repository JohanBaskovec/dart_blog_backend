import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/controller/blog_posts_controller.dart';
import 'package:blog_backend/src/postgres_connection_factory.dart';
import 'package:blog_backend/src/routing/router.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/typing/book_controller.dart';
import 'package:blog_backend/src/typing/text_repository.dart';
import 'package:blog_backend/src/typing/typing_text_controller.dart';
import 'package:blog_backend/src/utf8_stream_to_json_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_object_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_string_converter.dart';
import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';
import 'package:yaml/yaml.dart';

/// Load test data
Future<void> loadFixtures(
    PostgresConnectionFactory postgresConnectionFactory) async {
  final PostgreSQLConnection connection =
      await postgresConnectionFactory.newOpenConnection();

  final textRepository = TextRepository(connection);
  await textRepository.persist(Text('title 1', '''
Mr. Bennet was so odd a mixture of quick parts, sarcastic humour,
reserve, and caprice, that the experience of three-and-twenty years had
been insufficient to make his wife understand his character. _Her_ mind
was less difficult to develop. She was a woman of mean understanding,
little information, and uncertain temper. When she was discontented,
she fancied herself nervous. The business of her life was to get her
daughters married; its solace was visiting and news.'''));

  await textRepository.persist(Text('title 2', '''
In a few days Mr. Bingley returned Mr. Bennet's visit, and sat about
ten minutes with him in his library. He had entertained hopes of being
admitted to a sight of the young ladies, of whose beauty he had
heard much; but he saw only the father. The ladies were somewhat more
fortunate, for they had the advantage of ascertaining from an upper
window that he wore a blue coat, and rode a black horse.'''));
  await connection.close();
}

/// Run the application.
Future<void> run() async {
  try {
    const configurationFileName = 'conf.dev.yaml';
    final configurationFile = File(configurationFileName);
    if (!configurationFile.existsSync()) {
      print('$configurationFileName not found!');
      return;
    }
    final String configurationFileContent =
        configurationFile.readAsStringSync();
    final config = loadYaml(configurationFileContent);
    final int backendPort = config['backend_port'];
    final postgresConnectionFactory = PostgresConnectionFactory(
        config['db_host'] as String,
        config['db_port'] as int,
        config['db_name'] as String,
        config['db_username'] as String,
        config['db_password'] as String);
    if (config['load_fixtures'] as bool) {
      await loadFixtures(postgresConnectionFactory);
    }
    final HttpServer server =
        await HttpServer.bind(InternetAddress.anyIPv6, backendPort);
    print('Listening on http://localhost:$backendPort.');
    final blogPostsController = BlogPostsController();
    final textController = TypingTextController();
    final bookController = BookController();
    const utf8Decoder = Utf8Decoder();
    const utf8StreamToStringConverter =
        Utf8StreamToStringConverter(utf8Decoder);
    const utf8StreamToJsonConverter =
        Utf8StreamToJsonConverter(utf8StreamToStringConverter);
    const utf8StreamToObjectConverter =
        Utf8StreamToObjectConverter(utf8StreamToJsonConverter);
    const JsonEncoder jsonEncoder = JsonEncoder();
    final router = Router.createDefault();
    router.addController(blogPostsController);
    router.addController(textController);
    router.addController(bookController);
    server.listen((HttpRequest request) async {
      try {
        request.response.headers
            .add('Access-Control-Allow-Origin', config['frontend_url']);
        request.response.headers
            .add('Access-Control-Allow-Credentials', 'true');
        final routingContext = RoutingContext(
            request,
            jsonEncoder,
            utf8StreamToJsonConverter,
            utf8StreamToObjectConverter,
            postgresConnectionFactory);
        await router.routeToPath(request.uri.path, routingContext);
      } catch (e, s) {
        print(e);
        print(s);
      }
    });
  } catch (e, s) {
    print(e);
    print(s);
  }
}
