import 'dart:developer' as dev show log;

import 'package:firebase_browser/features/db_management/constants/db_constants.dart';
import 'package:firebase_browser/features/db_management/models/db_data.dart';
import 'package:firebase_browser/features/db_management/models/node.dart';
import 'package:firebase_browser/features/db_management/models/remote_db.dart';
import 'package:firebase_browser/features/db_management/services/local_db_service/local_db_service.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/db_provider.dart';
import 'package:firebase_browser/features/db_management/services/remote_db_service/db_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'db_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit()
    : super(
        DatabaseUninitializedState(
          isLoading: false,
          currentPath: DbConstants.home,
          selectedDbUrl: null,
        ),
      );

  DbProvider get db {
    final s = state;
    if (s is DatabaseInitializedState && s.selectedDbUrl != null) {
      return DbService.firebaseRealtime(s.selectedDbUrl!);
    }
    throw StateError("Attempted to access db before initialization");
  }

  void quit() => emit(state.copyWith(quit: true));

  Future<void> selectDb(String url) async {
    final DatabaseInitializedState initializedState =
        state as DatabaseInitializedState;
    emit(
      initializedState.copyWith(
        selectedDbUrl: url,
        currentPath: DbConstants.home,
      ),
    );
    load(Node.home());
  }

  Future<List<RemoteDatabase>> _getUserDbs() async =>
      await LocalDbService.getDatabases() ?? List.empty();

  Future<List<RemoteDatabase>>? loadDatabases() async {
    final List<RemoteDatabase> dbs = await _getUserDbs();
    emit(
      DatabaseInitializedState(
        dbs: dbs,
        isLoading: false,
        currentPath: DbConstants.home,
        data: null,
        selectedDbUrl: null,
      ),
    );
    return dbs;
  }

  Future<void> addDatabase({required String url, required String name}) async {
    try {
      if (state is DatabaseInitializedState) {
        final DatabaseInitializedState initializedState =
            state as DatabaseInitializedState;
        emit(initializedState.copyWith(isLoading: true));
        await LocalDbService.addRemoteDatabase(
          RemoteDatabase(name: name, url: url),
        );
        final List<RemoteDatabase> newDbs = await _getUserDbs();
        emit(initializedState.copyWith(dbs: newDbs, isLoading: false));
      }
    } catch (e) {
      dev.log("Error adding db: $e");
      final List<RemoteDatabase> dbs = await _getUserDbs();
      emit(
        DatabaseInitializedState(
          dbs: dbs,
          isLoading: false,
          currentPath: DbConstants.home,
          data: null,
          selectedDbUrl: null,
        ),
      );
    }
  }

  Future<void> deleteDatabase(RemoteDatabase remoteDb) async {
    try {
      if (state is DatabaseInitializedState) {
        final DatabaseInitializedState initializedState =
            state as DatabaseInitializedState;
        emit(initializedState.copyWith(isLoading: true));
        await LocalDbService.removeDatabase(remoteDb);
        final List<RemoteDatabase> newDbs = await _getUserDbs();
        emit(initializedState.copyWith(dbs: newDbs, isLoading: false));
      }
    } catch (e) {
      dev.log("Error deleting db: $e");
      final List<RemoteDatabase> dbs = await _getUserDbs();
      emit(
        DatabaseInitializedState(
          dbs: dbs,
          isLoading: false,
          currentPath: DbConstants.home,
          data: null,
          selectedDbUrl: null,
        ),
      );
    }
  }

  Future<void> load(Node node) async {
    try {
      final DatabaseInitializedState initializedState =
          state as DatabaseInitializedState;
      emit(initializedState.copyWith(isLoading: true));
      final String path = _appendPath(
        path: initializedState.currentPath,
        value: node.name,
      );
      final Iterable<DbData> data = await db.loadItem(path: path);
      emit(
        initializedState.copyWith(
          data: data,
          isLoading: false,
          currentPath: path,
        ),
      );
    } catch (e, stackTrace) {
      dev.log("Caught error: $e");
      dev.log("Stacktrace: $stackTrace");
    }
  }

  Future<void> backNode() async {
    try {
      final DatabaseInitializedState initializedState =
          state as DatabaseInitializedState;
      final String path = initializedState.currentPath;
      final int lastSlash = path.lastIndexOf('/');
      if (lastSlash == -1) {
        quit();
        return;
      }
      final String backPath = path.substring(0, lastSlash);
      emit(initializedState.copyWith(isLoading: true));
      final Iterable<DbData> data = await db.loadItem(path: backPath);
      emit(
        initializedState.copyWith(
          data: data,
          isLoading: false,
          currentPath: backPath,
        ),
      );
    } catch (e, stackTrace) {
      dev.log("Caught error: $e");
      dev.log("Stacktrace: $stackTrace");
    }
  }

  String _appendPath({required String path, required String value}) {
    if (value == DbConstants.home) {
      return path;
    }
    return "$path/$value";
  }
}
