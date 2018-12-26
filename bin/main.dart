import 'dart:io';

Future<void> main() async {
  final HttpServer server = await
  HttpServer.bind(InternetAddress.anyIPv6, 8082);
  server.listen((HttpRequest request) {
    request.response.write('hello world');
    request.response.close();
  });
}
