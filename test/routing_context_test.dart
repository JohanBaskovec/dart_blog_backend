import 'dart:io';

import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/routing_context_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mocks.dart';

void main() {
  MockHttpRequest request;
  // ignore: close_sinks
  MockHttpResponse response;
  MockHttpHeaders headers;
  MockJsonEncoder jsonEncoder;
  RoutingContext routingContext;
  setUp(() {
    request = MockHttpRequest();
    response = MockHttpResponse();
    when(request.response).thenReturn(response);
    headers = MockHttpHeaders();
    when(response.headers).thenReturn(headers);
    jsonEncoder = MockJsonEncoder();
    routingContext = RoutingContextImpl(request, jsonEncoder);
  });

  group('setJsonContentType', () {
    test('should set the content type to application/json; charset=utf-8', () {
      final expectedContentType =
          ContentType('application', 'json', charset: 'utf-8');
      ContentType receivedContentType;
      when(headers.contentType = any).thenAnswer((Invocation invocation) {
        if (invocation.isSetter) {
          receivedContentType =
              invocation.positionalArguments[0] as ContentType;
        }
      });
      routingContext.setJsonContentType();
      expect(
          receivedContentType.mimeType, equals(expectedContentType.mimeType));
      expect(
          receivedContentType.charset, equals(expectedContentType.charset));
      expect(receivedContentType.toString(),
          equals(expectedContentType.toString()));
    });
  });
  group('okResponse', () {
    test('should set the status code to 200 and set the body', () {
      routingContext.okResponse('hello world');
      verify(response.statusCode = 200);
      verify(response.write('hello world'));
    });
  });
  group('close', () {
    test('should close the response', () {
      routingContext.closeResponse();
      verify(response.close());
    });
  });
}
