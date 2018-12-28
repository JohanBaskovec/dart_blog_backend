import 'package:blog_backend/src/utf8_stream_to_string_converter.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  Utf8StreamToStringConverter utf8StreamToStringConverter;
  MockUtf8Decoder utf8Decoder;
  setUp(() {
    utf8Decoder = MockUtf8Decoder();
    utf8StreamToStringConverter = Utf8StreamToStringConverter(utf8Decoder);
  });
  group('streamToString', () {
    test('should convert stream to string', () async {
      final byteStream = MockStream<List<int>>();
      final stringStream = MockStream<String>();
      const expectedString = 'hello world';
      when(stringStream.join('')).thenAnswer((_) async => expectedString);
      when(utf8Decoder.bind(byteStream)).thenAnswer((_) => stringStream);
      final String str = await utf8StreamToStringConverter.streamToString(byteStream);
      expect(str, equals(expectedString));
    });
  });
}
