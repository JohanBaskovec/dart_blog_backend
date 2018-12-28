import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/controller/blog_posts_controller.dart';
import 'package:blog_backend/src/routing/route.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:blog_backend/src/routing/router.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/utf8_stream_to_json_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_string_converter.dart';

/// Run the application.
Future<void> run() async {
  final HttpServer server =
      await HttpServer.bind(InternetAddress.anyIPv6, 8082);
  final getBlogPostsController = BlogPostsController();
  const utf8Decoder = Utf8Decoder();
  const utf8StreamToStringConverter = Utf8StreamToStringConverter(utf8Decoder);
  const utf8StreamToJsonConverter = Utf8StreamToJsonConverter(utf8StreamToStringConverter);
  const JsonEncoder jsonEncoder = JsonEncoder();
  final router = Router(RouteHolder([Route('/posts', getBlogPostsController)]));
  server.listen((HttpRequest request) async {
    try {
      final routingContext =
          RoutingContext(request, jsonEncoder, utf8StreamToJsonConverter);
      await router.routeToPath(request.uri.path, routingContext);
    } catch (e, s) {
      print(e);
      print(s);
    }
  });
}
