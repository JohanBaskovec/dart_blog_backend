import 'package:blog_backend/src/controller.dart';

/// A route that maps a URL pattern to a Controller.
class Route {
  /// The path pattern.
  final RegExp pathRegexp;
  /// The controller.
  final Controller controller;

  /// Creates a new route that links the [pathRegexp]
  /// to the [controller]'s run method.
  Route(String regexp, this.controller)
      : pathRegexp = RegExp(regexp);

  /// Checks if a path matches.
  bool matches(String path) {
    return pathRegexp.hasMatch(path);
  }
}
