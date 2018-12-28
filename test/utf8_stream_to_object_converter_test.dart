import 'package:blog_backend/src/utf8_stream_to_object_converter.dart';
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
  MockUtf8StreamToJsonConverter utf8StreamToJsonConverter;
  Utf8StreamToObjectConverter utf8StreamToObjectConverter;
  setUp(() {
    utf8StreamToJsonConverter = MockUtf8StreamToJsonConverter();
    utf8StreamToObjectConverter = Utf8StreamToObjectConverter(utf8StreamToJsonConverter);
  });
  group('streamToObject', () {
    test('should convert stream to object', () async {
      final byteStream = MockStream<List<int>>();
      const Map<String, String> json = {'hello': 'world'};
      when(utf8StreamToJsonConverter.streamToJson(byteStream))
          .thenAnswer((_) async => json);
      final TargetObject o =
          await utf8StreamToObjectConverter.streamToObject(byteStream, TargetObject.toJson);
      expect(o.hello, equals('world'));
    });
  });
}
