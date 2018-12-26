import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing/route.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:mockito/mockito.dart';

class MockController extends Mock implements Controller {}

class MockRoute extends Mock implements Route {}
class MockRouteHolder extends Mock implements RouteHolder {}
class MockRoutingContext extends Mock implements RoutingContext {}
class MockHttpRequest extends Mock implements HttpRequest {}
class MockHttpResponse extends Mock implements HttpResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}
class MockBlogPostRepository extends Mock implements BlogPostRepository {}
class MockJsonEncoder extends Mock implements JsonEncoder {}
