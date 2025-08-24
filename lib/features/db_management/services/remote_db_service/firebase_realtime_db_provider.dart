import 'package:firebase_browser/features/db_management/models/remote_db.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/db_provider.dart';

class FirebaseRealtimeDbProvider implements DbProvider {
  @override
  Future<RemoteDatabase> addRemoteDatabase({
    required String url,
    required String name,
  }) {
    // TODO: implement addRemoteDatabase (ADD TO LOCAL DB SQFLITE)
    throw UnimplementedError();
  }

  @override
  Future<List<RemoteDatabase>> loadDatabases() {
    // TODO: implement loadDatabases (LOAD DB FROM SQFLITE)
    throw UnimplementedError();
  }
}
