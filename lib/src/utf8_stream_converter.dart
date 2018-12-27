import 'dart:convert';

/// Converter of stream of bytes to json and objects.
class Utf8StreamConverter {
  final Utf8Decoder _utf8Decoder;

  /// Creates a new instance of [Utf8StreamConverter]
  const Utf8StreamConverter(this._utf8Decoder);

  /// Reads all the bytes from the stream as a UTF-8 string.
  Future<String> streamToString(Stream<List<int>> stream) {
    return _utf8Decoder.bind(stream).join('');
  }

  /// Reads all the bytes from the stream as JSON
  Future<dynamic> streamToJson(Stream<List<int>> stream) async {
    final String json = await streamToString(stream);
    return jsonDecode(json);
  }
}
