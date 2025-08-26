import 'package:firebase_browser/features/db_management/models/db_data.dart';

abstract class DbProvider {
  Future<List<DbData>> loadItem({required String path});
}
