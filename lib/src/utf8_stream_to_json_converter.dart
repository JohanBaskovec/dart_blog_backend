import 'dart:convert';

import 'package:blog_backend/src/utf8_stream_to_string_converter.dart';

/// Converter of stream of bytes to json
class Utf8StreamToJsonConverter {
  final Utf8StreamToStringConverter _utf8StreamToStringConverter;

  /// Creates a new instance of [Utf8StreamToJsonConverter]
  const Utf8StreamToJsonConverter(this._utf8StreamToStringConverter);

  /// Reads all the bytes from the stream as JSON
  Future<dynamic> streamToJson(Stream<List<int>> stream) async {
    final String json = await _utf8StreamToStringConverter.streamToString(stream);
    return jsonDecode(json);
  }
}
