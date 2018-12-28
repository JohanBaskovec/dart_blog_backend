import 'dart:convert';

/// Converter of stream of bytes to json and objects.
class Utf8StreamToStringConverter {
  final Utf8Decoder _utf8Decoder;

  /// Creates a new instance of [Utf8StreamToStringConverter]
  const Utf8StreamToStringConverter(this._utf8Decoder);

  /// Reads all the bytes from the stream as a UTF-8 string.
  Future<String> streamToString(Stream<List<int>> stream) {
    return _utf8Decoder.bind(stream).join('');
  }
}
