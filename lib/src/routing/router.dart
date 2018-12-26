import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing/route_holder.dart';

/// A Router.
class Router {
  RouteHolder _routeHolder;

  /// Creates a new Router instance.
  Router(this._routeHolder);

  /// Find the first Controller that matches [path]
  /// in the routes and calls its run method.
  /// Does nothing if no controller matches.
  void routeToPath(String path) {
    final Controller controller = _routeHolder.getMatchingController(path);
    if (controller != null) {
      controller.run();
    } else {
      // TODO: show error
    }
  }
}