import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/controller/blog_posts_controller.dart';
import 'package:blog_backend/src/routing/route.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:blog_backend/src/routing/router.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/utf8_stream_converter.dart';

/// Run the application.
Future<void> run() async {
  final HttpServer server =
      await HttpServer.bind(InternetAddress.anyIPv6, 8082);
  final getBlogPostsController = BlogPostsController();
  const utf8Decoder = Utf8Decoder();
  const utf8StreamConverter = Utf8StreamConverter(utf8Decoder);
  const JsonEncoder jsonEncoder = JsonEncoder();
  final router = Router(RouteHolder([Route('/posts', getBlogPostsController)]));
  server.listen((HttpRequest request) async {
    try {
      final routingContext =
          RoutingContext(request, jsonEncoder, utf8StreamConverter);
      await router.routeToPath(request.uri.path, routingContext);
    } catch (e, s) {
      print(e);
      print(s);
    }
  });
}
