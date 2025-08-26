import 'package:firebase_browser/features/db_management/models/db_data.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/db_provider.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/firebase_realtime_db_provider.dart';

class DbService implements DbProvider {
  final DbProvider provider;
  DbService({required this.provider});

  factory DbService.firebaseRealtime(String url) =>
      DbService(provider: FirebaseRealtimeDbProvider(dbUrl: url));

  @override
  Future<List<DbData>> loadItem({required String path, bool shallow = true}) =>
      provider.loadItem(path: path);
}
