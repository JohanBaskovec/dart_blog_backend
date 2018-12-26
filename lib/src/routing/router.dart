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
    final Controller controller = _routeHolder.getMatchingController(path);
    if (controller != null) {
      await controller.run(routingContext);
      routingContext.closeResponse();
    } else {
      // TODO: send 404 error
      routingContext.closeResponse();
    }
  }
}