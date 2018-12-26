import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_backend/src/blog/repository/blog_post_repository_impl.dart';
import 'package:blog_backend/src/routing_context.dart';

/// A routing context. Wraps a dart:io HttpRequest, simplifies
/// responding to requests and is a service locator.
class RoutingContextImpl implements RoutingContext {
  HttpRequest _request;
  JsonEncoder _jsonEncoder;
  BlogPostRepository _blogPostRepository;

  /// Creates a next RoutingContext from a dart:io HttpRequest
  RoutingContextImpl(this._request, this._jsonEncoder);

  @override
  void setJsonContentType() {
    _request.response.headers.contentType =
      ContentType('application', 'json', charset: 'utf-8');
  }

  @override
  void okResponse(String body) {
    _request.response.statusCode = HttpStatus.ok;
    _request.response.write(body);
  }

  @override
  void methodNotAllowedResponse() {
    _request.response.statusCode = HttpStatus.methodNotAllowed;
  }

  @override
  void closeResponse() {
    _request.response.close();
  }

  @override
  BlogPostRepository get blogPostRepository {
    return _blogPostRepository ??= BlogPostRepositoryImpl();
  }

  @override
  JsonEncoder get jsonEncoder => _jsonEncoder;

  @override
  String get method => _request.method;

  @override
  void notFoundResponse() {
    _request.response.statusCode = HttpStatus.notFound;
  }

  @override
  void okJsonResponse(dynamic objects) {
    final String json = jsonEncoder.convert(objects);
    okResponse(json);
  }
}
