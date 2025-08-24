import 'dart:io';

import 'package:firebase_browser/features/db_management/models/remote_db.dart';
import 'package:firebase_browser/features/db_management/services/local_db_service/execution.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class LocalDbService {
  static Database? _db;

  static DatabaseFactory getDatabaseFactory() {
    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile
      return databaseFactory;
    } else {
      // FFI for desktop
      sqfliteFfiInit();
      return databaseFactoryFfi;
    }
  }

  static Future<Database> _getDB() async {
    if (_db != null) return _db!;

    final dbFactory = getDatabaseFactory();
    String dbPath;
    if (Platform.isAndroid || Platform.isIOS) {
      dbPath = join(await getDatabasesPath(), SqfliteExec.dbName);
    } else {
      // On desktop, pick a folder manually (e.g. current directory)
      final dbFolder = await databaseFactoryFfi.getDatabasesPath();
      dbPath = join(dbFolder, SqfliteExec.dbName);
    }

    _db = await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: SqfliteExec.version,
        onCreate: (db, version) async {
          await db.execute(SqfliteExec.createDB);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // NOTE: do not use else if
        },
      ),
    );
    return _db!;
  }

  static Future<RemoteDatabase> addRemoteDatabase(
    RemoteDatabase remoteDb,
  ) async {
    final db = await _getDB();
    await db.insert(
      SqfliteExec.databasesTableName,
      remoteDb.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return remoteDb;
  }

  static Future<List<RemoteDatabase>?> getDatabases() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> rows = await db.query(
      SqfliteExec.databasesTableName,
    );
    if (rows.isEmpty) return null;
    return List.generate(
      rows.length,
      (index) => RemoteDatabase.fromJson(rows[index]),
    );
  }

  static Future<RemoteDatabase> removeDatabase(RemoteDatabase remoteDb) async {
    final db = await _getDB();
    await db.delete(
      SqfliteExec.databasesTableName,
      where: "url = ?",
      whereArgs: [remoteDb.url],
    );
    return remoteDb;
  }
}
