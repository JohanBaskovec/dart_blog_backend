import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:blog_backend/src/routing_context.dart';

/// A Router.
class Router {
  RouteHolder _routeHolder;

  /// Creates a new Router instance.
  Router(this._routeHolder);

  /// Find the first Controller that matches [path]
  /// in the routes and calls its run method.
  /// Does nothing if no controller matches.
  Future<void> routeToPath(String path, RoutingContext routingContext) async {
    try {
      final Controller controller = _routeHolder.getMatchingController(path);
      if (controller != null) {
        switch (routingContext.method) {
          case 'GET':
            await controller.get(routingContext);
            break;
          case 'POST':
            await controller.post(routingContext);
            break;
          case 'PUT':
            await controller.put(routingContext);
            break;
          case 'DELETE':
            await controller.delete(routingContext);
            break;
          default:
            routingContext.methodNotAllowedResponse();
            break;
        }
      } else {
        routingContext.notFoundResponse();
      }
    } catch (e, s) {
      routingContext.internalServerErrorResponse();
      print(e);
      print(s);
    } finally {
      routingContext.closeResponse();
    }
  }
}