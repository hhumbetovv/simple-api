import 'dart:io';

import 'package:firebase_dart/firebase_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import '../endpoints/users.dart';

final API api = API();

void main(List<String> args) async {
  FirebaseDart.setup();

  final ip = InternetAddress.anyIPv4;
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(api.userHandler);
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final userServer = await serve(handler, ip, port);

  print('Server listening on port ${userServer.port}');
}
