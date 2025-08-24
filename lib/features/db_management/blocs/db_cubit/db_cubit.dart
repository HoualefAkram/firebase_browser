import 'dart:developer' as dev show log;

import 'package:firebase_browser/features/db_management/models/remote_db.dart';
import 'package:firebase_browser/features/db_management/services/local_db_service/local_db_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'db_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseUninitializedState(isLoading: false));

  Future<List<RemoteDatabase>> _getUserDbs() async =>
      await LocalDbService.getDatabases() ?? List.empty();

  Future<List<RemoteDatabase>>? loadDatabases() async {
    final List<RemoteDatabase> dbs = await _getUserDbs();
    emit(DatabaseInitializedState(dbs: dbs, isLoading: false));
    return dbs;
  }

  Future<void> addDatabase({required String url, required String name}) async {
    try {
      if (state is DatabaseInitializedState) {
        final DatabaseInitializedState initializedState =
            state as DatabaseInitializedState;
        emit(
          DatabaseInitializedState(dbs: initializedState.dbs, isLoading: true),
        );
        await LocalDbService.addRemoteDatabase(
          RemoteDatabase(name: name, url: url),
        );
        final List<RemoteDatabase> newDbs = await _getUserDbs();
        emit(DatabaseInitializedState(dbs: newDbs, isLoading: false));
      }
    } catch (e) {
      dev.log("Error adding db: $e");
      final List<RemoteDatabase> dbs = await _getUserDbs();
      emit(DatabaseInitializedState(dbs: dbs, isLoading: false));
    }
  }

  Future<void> deleteDatabase(RemoteDatabase remoteDb) async {
    try {
      if (state is DatabaseInitializedState) {
        final DatabaseInitializedState initializedState =
            state as DatabaseInitializedState;
        emit(
          DatabaseInitializedState(dbs: initializedState.dbs, isLoading: true),
        );
        await LocalDbService.removeDatabase(remoteDb);
        final List<RemoteDatabase> newDbs = await _getUserDbs();
        emit(DatabaseInitializedState(dbs: newDbs, isLoading: false));
      }
    } catch (e) {
      dev.log("Error deleting db: $e");
      final List<RemoteDatabase> dbs = await _getUserDbs();
      emit(DatabaseInitializedState(dbs: dbs, isLoading: false));
    }
  }
}
