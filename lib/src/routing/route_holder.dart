import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing/route.dart';

/// Holds Routes.
class RouteHolder {
  List<Route> _routes;

  /// Create a new RouteHolder.
  RouteHolder(this._routes);

  /// Get the first Route that matches [requestedPath].
  Controller getMatchingController(String requestedPath) {
    for (Route route in _routes) {
      if (route.matches(requestedPath)) {
        return route.controller;
      }
    }
    return null;
  }

  void addRoute(Route route) {
    _routes.add(route);
  }

  void addRoutes(List<Route> routes) {
    _routes.addAll(routes);
  }
}