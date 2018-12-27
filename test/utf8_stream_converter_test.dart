import 'package:blog_backend/src/utf8_stream_converter.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  Utf8StreamConverter utf8StreamConverter;
  MockUtf8Decoder utf8Decoder;
  setUp(() {
    utf8Decoder = MockUtf8Decoder();
    utf8StreamConverter = Utf8StreamConverter(utf8Decoder);
  });
  group('streamToString', () {
    test('should convert stream to string', () async {
      final byteStream = MockStream<List<int>>();
      final stringStream = MockStream<String>();
      const expectedString = 'hello world';
      when(stringStream.join('')).thenAnswer((_) async => expectedString);
      when(utf8Decoder.bind(byteStream)).thenAnswer((_) => stringStream);
      final String str = await utf8StreamConverter.streamToString(byteStream);
      expect(str, equals(expectedString));
    });
  });
  group('streamToJson', () {
    test('should convert stream to json', () async {
      final byteStream = MockStream<List<int>>();
      final stringStream = MockStream<String>();
      const expectedString = '{"hello": "world"}';
      const Map<String, dynamic> expectedJson = {
        'hello': 'world'
      };
      when(stringStream.join('')).thenAnswer((_) async => expectedString);
      when(utf8Decoder.bind(byteStream)).thenAnswer((_) => stringStream);
      final Map<String, dynamic> json = await utf8StreamConverter.streamToJson(byteStream);
      expect(json, equals(expectedJson));
    });
  });
}
