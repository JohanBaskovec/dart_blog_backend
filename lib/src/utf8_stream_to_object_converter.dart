import 'package:blog_backend/src/utf8_stream_to_json_converter.dart';

/// Converter of stream of bytes to object
class Utf8StreamToObjectConverter {
  final Utf8StreamToJsonConverter _utf8StreamToJsonConverter;

  /// Creates a new instance of [Utf8StreamToJsonConverter]
  const Utf8StreamToObjectConverter(this._utf8StreamToJsonConverter);

  /// Reads all the bytes from the stream and attempts to convert it to JSON
  Future<T> streamToObject<T>(Stream<List<int>> stream, T conversionFunction(Map<String, dynamic> obj)) async {
    final dynamic json = await _utf8StreamToJsonConverter.streamToJson(stream);
    return conversionFunction(json as Map<String, dynamic>);
  }
}
