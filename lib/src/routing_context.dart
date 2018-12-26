import 'dart:convert';

import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';

/// Routing context
abstract class RoutingContext {
  /// Set the content type to application/json utf-8
  void setJsonContentType();

  /// Respond with a code 200.
  void okResponse(String body);

  /// Close the response.
  void closeResponse();

  /// Get or create a BlogPostRepository
  BlogPostRepository get blogPostRepository;

  /// Get a JsonEncoder
  JsonEncoder get jsonEncoder;
}

