part of 'db_cubit.dart';

sealed class DatabaseState {
  final bool isLoading; // loading pop up

  DatabaseState({required this.isLoading});
}

// loading Dbs
final class DatabaseUninitializedState extends DatabaseState {
  DatabaseUninitializedState({required super.isLoading});
}

// Dbs loaded
final class DatabaseInitializedState extends DatabaseState {
  final List<RemoteDatabase> dbs;

  DatabaseInitializedState({required this.dbs, required super.isLoading});

  DatabaseInitializedState copyWith({
    List<RemoteDatabase>? dbs,
    bool? isLoading,
  }) => DatabaseInitializedState(
    dbs: dbs ?? this.dbs,
    isLoading: isLoading ?? this.isLoading,
  );
}
