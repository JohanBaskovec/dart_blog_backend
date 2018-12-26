import 'package:blog_backend/src/routing_context.dart';

/// Backend controller.
abstract class Controller {
  /// Run.
  Future<void> run(RoutingContext routingContext) async {

  }
}