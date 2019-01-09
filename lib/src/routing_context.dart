import 'dart:convert';
import 'dart:io';

import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_backend/src/postgres_connection_factory.dart';
import 'package:blog_backend/src/typing/book_repository.dart';
import 'package:blog_backend/src/typing/text_repository.dart';
import 'package:blog_backend/src/user/user_repository.dart';
import 'package:blog_backend/src/utf8_stream_to_json_converter.dart';
import 'package:blog_backend/src/utf8_stream_to_object_converter.dart';
import 'package:postgres/postgres.dart';

/// A routing context. Wraps a dart:io's [HttpRequest], simplifies
/// responding to requests and is a service locator.
class RoutingContext {
  HttpRequest _request;
  JsonEncoder _jsonEncoder;
  BlogPostRepository _blogPostRepository;
  TextRepository _textRepository;
  BookRepository _bookRepository;
  UserRepository _userRepository;
  PostgreSQLConnection _connection;
  Utf8StreamToJsonConverter _utf8StreamParser;
  Utf8StreamToObjectConverter _utf8streamToObjectConverter;
  PostgresConnectionFactory _postgresConnectionFactory;

  /// See [HttpRequest.requestedUri]
  Uri get requestedUri => _request.requestedUri;

  /// Creates a next RoutingContext from a dart:io HttpRequest
  RoutingContext(this._request, this._jsonEncoder, this._utf8StreamParser,
      this._utf8streamToObjectConverter, this._postgresConnectionFactory);

  // TODO: connection pool
  // TODO: transactions
  Future<void> _openPostgresConnection() async {
    _connection = await _postgresConnectionFactory.newOpenConnection();
  }

  /// Sets the content type to application/json utf-8
  void setJsonContentType() {
    _request.response.headers.contentType =
        ContentType('application', 'json', charset: 'utf-8');
  }

  /// Responds with code 500.
  void internalServerErrorResponse() {
    _request.response.statusCode = HttpStatus.internalServerError;
  }

  /// Responds with a code 200.
  void okResponse(String body) {
    _request.response.statusCode = HttpStatus.ok;
    _request.response.write(body);
  }

  /// Responds with code 405 Method Not Allowed.
  void methodNotAllowedResponse() {
    _request.response.statusCode = HttpStatus.methodNotAllowed;
  }

  /// Closes the response. You generally don't need to call this
  /// method manually, the Router does it at the end of each request.
  void closeResponse() {
    if (_connection != null) {
      _connection.close();
    }
    _request.response.close();
  }

  /// Gets or create a BlogPostRepository
  Future<BlogPostRepository> get blogPostRepository async {
    if (_connection == null) {
      await _openPostgresConnection();
    }
    return _blogPostRepository ??= BlogPostRepository(_connection);
  }

  /// Gets or create a [TextRepository]
  Future<TextRepository> get textRepository async {
    if (_connection == null) {
      await _openPostgresConnection();
    }
    return _textRepository ??= TextRepository(_connection);
  }

  /// Gets or create a [BookRepository]
  Future<BookRepository> get bookRepository async {
    if (_connection == null) {
      await _openPostgresConnection();
    }
    return _bookRepository ??=
        BookRepository(_connection, await textRepository);
  }

  Future<UserRepository> get userRepository async {
    if (_connection == null) {
      await _openPostgresConnection();
    }
    return _userRepository ??= UserRepository(_connection);
  }

  /// Gets a JsonEncoder
  JsonEncoder get jsonEncoder => _jsonEncoder;

  /// Gets the method.
  String get method => _request.method;

  /// Responds with code 404.
  void notFoundResponse() {
    _request.response.statusCode = HttpStatus.notFound;
  }

  /// Responds with code 201.
  void createdResponse() {
    _request.response.statusCode = HttpStatus.created;
  }

  /// Attempts to convert [objects] to JSON and respond with a code 200.
  void okJsonResponse(dynamic objects) {
    final String json = jsonEncoder.convert(objects);
    okResponse(json);
  }

  /// Returns the body as a JSON object.
  Future<dynamic> get bodyAsJson {
    return _utf8StreamParser.streamToJson(_request);
  }

  /// Converts the JSON body to an object using [conversionFunction]
  Future<dynamic> getBodyAsObject(conversionFunction(Map<String, dynamic> o)) {
    return _utf8streamToObjectConverter.streamToObject(
        _request, conversionFunction);
  }

  Future<PostgreSQLConnection> get sqlConnection async {
    if (_connection == null) {
      await _openPostgresConnection();
    }
    return _connection;
  }
}
