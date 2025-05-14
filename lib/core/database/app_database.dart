import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart' as web;

class AppDatabase {
  Database? db;

  Future<void> init() async {
    String dbName = 'local.db';
    if (kIsWeb) {
      db = await web.databaseFactoryWeb.openDatabase(dbName);
    } else {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      db = await databaseFactoryIo.openDatabase(
        '${documentsDirectory.path}/$dbName',
      );
    }
  }
}
