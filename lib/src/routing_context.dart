import 'dart:convert';

import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';

/// Routing context
abstract class RoutingContext {
  /// Sets the content type to application/json utf-8
  void setJsonContentType();

  /// Responds with code 405 Method Not Allowed.
  void methodNotAllowedResponse();

  /// Responds with code 404.
  void notFoundResponse();

  /// Responds with a code 200.
  void okResponse(String body);

  /// Attempts to convert [objects] to JSON and respond with a code 200.
  void okJsonResponse(dynamic objects);

  /// Closes the response. You generally don't need to call this
  /// method manually, the Router does it at the end of each request.
  void closeResponse();

  /// Gets or create a BlogPostRepository
  BlogPostRepository get blogPostRepository;

  /// Gets a JsonEncoder
  JsonEncoder get jsonEncoder;

  /// Gets the method.
  String get method;
}

