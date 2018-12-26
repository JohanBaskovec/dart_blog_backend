import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing/route.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:mockito/mockito.dart';

class MockController extends Mock implements Controller {}

class MockRoute extends Mock implements Route {}
class MockRouteHolder extends Mock implements RouteHolder {}
