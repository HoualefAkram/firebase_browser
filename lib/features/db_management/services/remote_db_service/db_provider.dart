import 'package:firebase_browser/features/db_management/models/remote_db.dart';

abstract class DbProvider {
  Future<List<RemoteDatabase>> loadDatabases();

  Future<RemoteDatabase> addRemoteDatabase({
    required String url,
    required String name,
  });
}
