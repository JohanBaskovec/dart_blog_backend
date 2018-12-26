import 'dart:io';

/// Routing context
abstract class RoutingContext {
  /// Set the content type to application/json utf-8
  void setJsonContentType();

  /// Respond with a code 200.
  void okResponse(String body);

  /// Close the response.
  void closeResponse();
}