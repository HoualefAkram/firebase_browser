import 'package:firebase_browser/features/db_management/models/remote_db.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/db_provider.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/firebase_realtime_db_provider.dart';

class DbService implements DbProvider {
  final DbProvider provider;
  DbService({required this.provider});

  factory DbService.firebaseRealtime() =>
      DbService(provider: FirebaseRealtimeDbProvider());

  @override
  Future<RemoteDatabase> addRemoteDatabase({
    required String url,
    required String name,
  }) => provider.addRemoteDatabase(url: url, name: name);

  @override
  Future<List<RemoteDatabase>> loadDatabases() => provider.loadDatabases();
}
