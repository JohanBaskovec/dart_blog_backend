import 'package:blog_backend/src/utf8_stream_to_json_converter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mocks.dart';

void main() {
  MockUtf8StreamToStringConverter utf8StreamtoStringConverter;
  Utf8StreamToJsonConverter utf8StreamToJsonConverter;
  setUp(() {
    utf8StreamtoStringConverter = MockUtf8StreamToStringConverter();
    utf8StreamToJsonConverter =
        Utf8StreamToJsonConverter(utf8StreamtoStringConverter);
  });
  group('streamToJson', () {
    test('should convert stream to json', () async {
      final byteStream = MockStream<List<int>>();
      const jsonAsString = '{"hello": "world"}';
      const Map<String, dynamic> expectedJson = {'hello': 'world'};
      when(utf8StreamtoStringConverter.streamToString(byteStream))
          .thenAnswer((_) async => jsonAsString);
      final Map<String, dynamic> json =
          await utf8StreamToJsonConverter.streamToJson(byteStream);
      expect(json, equals(expectedJson));
    });
  });
}
