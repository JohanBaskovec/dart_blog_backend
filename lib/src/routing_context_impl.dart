import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_backend/src/blog/repository/blog_post_repository_impl.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/utf8_stream_converter.dart';
import 'package:postgres/postgres.dart';

/// A routing context. Wraps a dart:io HttpRequest, simplifies
/// responding to requests and is a service locator.
class RoutingContextImpl implements RoutingContext {
  HttpRequest _request;
  JsonEncoder _jsonEncoder;
  BlogPostRepository _blogPostRepository;
  PostgreSQLConnection _connection;
  Utf8StreamConverter _utf8StreamParser;

  // TODO: connection pool
  // TODO: transactions
  Future<void> _openPostgresConnection() async {
    _connection = PostgreSQLConnection('localhost', 5432, 'postgres',
        username: 'postgres', password: 'c4ef37c0fbd747da1c63c0f87d7c62df');
    await _connection.open();
  }

  /// Creates a next RoutingContext from a dart:io HttpRequest
  RoutingContextImpl(this._request, this._jsonEncoder, this._utf8StreamParser);

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
    if (_connection != null) {
      _connection.close();
    }
    _request.response.close();
  }

  @override
  Future<BlogPostRepository> get blogPostRepository async {
    if (_connection == null) {
      await _openPostgresConnection();
    }
    return _blogPostRepository ??= BlogPostRepositoryImpl(_connection);
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

  @override
  Future<dynamic> get bodyAsJson {
    return _utf8StreamParser.streamToJson(_request);
  }
}
