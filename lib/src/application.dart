import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/controller/get_blog_posts_controller.dart';
import 'package:blog_backend/src/routing/route.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:blog_backend/src/routing/router.dart';
import 'package:blog_backend/src/routing_context_impl.dart';
import 'package:postgres/postgres.dart';

/// Run the application.
Future<void> run() async {
  final HttpServer server =
      await HttpServer.bind(InternetAddress.anyIPv6, 8082);
  final getBlogPostsController = GetBlogPostsController();
  const JsonEncoder jsonEncoder = JsonEncoder();
  final router = Router(RouteHolder([Route('/posts', getBlogPostsController)]));
  server.listen((HttpRequest request) async {
    try {
      final routingContext = RoutingContextImpl(request, jsonEncoder);
      await router.routeToPath(request.uri.path, routingContext);
    } catch (e, s) {
      print(e);
      print(s);
    }
  });
}
