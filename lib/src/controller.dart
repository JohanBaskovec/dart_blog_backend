import 'package:blog_backend/src/routing_context.dart';

/// Backend controller.
abstract class Controller {
  /// GET
  Future<void> get(RoutingContext routingContext) async {
    routingContext.methodNotAllowedResponse();
  }

  /// POST
  Future<void> post(RoutingContext routingContext) async {
    routingContext.methodNotAllowedResponse();
  }

  /// PUT
  Future<void> put(RoutingContext routingContext) async {
    routingContext.methodNotAllowedResponse();
  }

  /// DELETE
  Future<void> delete(RoutingContext routingContext) async {
    routingContext.methodNotAllowedResponse();
  }
}