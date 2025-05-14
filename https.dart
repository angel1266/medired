import 'dart:io';
import 'dart:convert';

void main() async {


  final HttpServer server = await HttpServer.bind(
    InternetAddress.loopbackIPv4, 8443
  );
  print('Listening on https://${server.address.address}:${server.port}');

  await for (HttpRequest request in server) {
    final Uri uri = request.uri;
    final String path = uri.path == '/' ? '/index.html' : uri.path;
    final File file = File('build/web$path');

    if (await file.exists()) {
      final List<int> bytes = await file.readAsBytes();
      final String mimeType = _getMimeType(path);

      request.response
        ..headers.contentType = ContentType.parse(mimeType)
        ..add(bytes);
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found');
    }

    await request.response.close();
  }
}

String _getMimeType(String path) {
  if (path.endsWith('.html')) return 'text/html; charset=utf-8';
  if (path.endsWith('.css')) return 'text/css; charset=utf-8';
  if (path.endsWith('.js')) return 'application/javascript; charset=utf-8';
  if (path.endsWith('.png')) return 'image/png';
  if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
  if (path.endsWith('.gif')) return 'image/gif';
  return 'application/octet-stream';
}