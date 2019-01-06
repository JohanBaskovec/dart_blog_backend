import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/controller/blog_posts_controller.dart';
import 'package:blog_backend/src/routing/route.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:blog_backend/src/routing/router.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/typing/book_controller.dart';
import 'package:blog_backend/src/typing/typing_text_controller.dart';
import 'package:blog_backend/src/utf8_stream_to_json_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_object_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_string_converter.dart';

/// Run the application.
Future<void> run() async {
  final HttpServer server =
      await HttpServer.bind(InternetAddress.anyIPv6, 8082);
  final blogPostsController = BlogPostsController();
  final textController = TypingTextController();
  final bookController = BookController();
  const utf8Decoder = Utf8Decoder();
  const utf8StreamToStringConverter = Utf8StreamToStringConverter(utf8Decoder);
  const utf8StreamToJsonConverter =
      Utf8StreamToJsonConverter(utf8StreamToStringConverter);
  const utf8StreamToObjectConverter =
      Utf8StreamToObjectConverter(utf8StreamToJsonConverter);
  const JsonEncoder jsonEncoder = JsonEncoder();
  final router = Router(RouteHolder([
    Route('/posts', blogPostsController),
    Route('/texts', textController),
    Route('/books', bookController)
  ]));
  server.listen((HttpRequest request) async {
    try {
      request.response.headers.add('Access-Control-Allow-Origin', 'http://localhost:8080');
      request.response.headers.add('Access-Control-Allow-Credentials', 'true');
      final routingContext = RoutingContext(request, jsonEncoder,
          utf8StreamToJsonConverter, utf8StreamToObjectConverter);
      await router.routeToPath(request.uri.path, routingContext);
    } catch (e, s) {
      print(e);
      print(s);
    }
  });
}
