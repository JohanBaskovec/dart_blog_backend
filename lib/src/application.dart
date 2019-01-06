import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/controller/blog_posts_controller.dart';
import 'package:blog_backend/src/postgres_connection_factory.dart';
import 'package:blog_backend/src/routing/router.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/typing/book_controller.dart';
import 'package:blog_backend/src/typing/typing_text_controller.dart';
import 'package:blog_backend/src/utf8_stream_to_json_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_object_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_string_converter.dart';
import 'package:yaml/yaml.dart';

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
