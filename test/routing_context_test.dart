import 'dart:io';

import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_common/blog_common.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mocks.dart';

class TargetObject {
  String hello;

  static TargetObject toJson(Map<String, dynamic> json) {
    final ret = TargetObject();
    ret.hello = json['hello'] as String;
    return ret;
  }
}

void main() {
  MockHttpRequest request;
  // ignore: close_sinks
  MockHttpResponse response;
  MockHttpHeaders headers;
  MockJsonEncoder jsonEncoder;
  RoutingContext routingContext;
  MockUtf8StreamToJsonConverter utf8StreamToJsonConverter;
  MockUtf8StreamToObjectConverter utf8StreamToObjectConverter;
  setUp(() {
    request = MockHttpRequest();
    response = MockHttpResponse();
    when(request.response).thenReturn(response);
    headers = MockHttpHeaders();
    when(response.headers).thenReturn(headers);
    jsonEncoder = MockJsonEncoder();
    utf8StreamToJsonConverter = MockUtf8StreamToJsonConverter();
    utf8StreamToObjectConverter = MockUtf8StreamToObjectConverter();
    routingContext = RoutingContext(request, jsonEncoder,
        utf8StreamToJsonConverter, utf8StreamToObjectConverter);
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
      expect(receivedContentType.charset, equals(expectedContentType.charset));
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
  group('okJsonResponse', () {
    test('should set the status code to 200, convert to json and set the body',
        () {
      final blogPost = BlogPost(title: 'title0', content: 'content0');
      const String json = '{"title": "title0", "content": "content0"}';
      when(jsonEncoder.convert(blogPost)).thenReturn(json);
      routingContext.okJsonResponse(blogPost);
      verify(response.statusCode = 200);
      verify(response.write(json));
    });
  });

  group('close', () {
    test('should close the response', () {
      routingContext.closeResponse();
      verify(response.close());
    });
  });

  group('bodyAsJson', () {
    test('should return the body as json', () async {
      final Map<String, dynamic> json = {'hello': 'world'};
      when(utf8StreamToJsonConverter.streamToJson(request))
          .thenAnswer((_) async => json);
      final dynamic ret = await routingContext.bodyAsJson;
      expect(ret, equals(json));
    });
  });

  group('bodyAsObject', () {
    test('should return the body as an object', () async {
      final expected = TargetObject();
      when(utf8StreamToObjectConverter.streamToObject(
              request, TargetObject.toJson))
          .thenAnswer((_) async => expected);
      final ret = await routingContext.getBodyAsObject(TargetObject.toJson);
      expect(ret, same(expected));
    });
  });
}
