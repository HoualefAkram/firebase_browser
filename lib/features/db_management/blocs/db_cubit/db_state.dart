part of 'db_cubit.dart';

class DatabaseState {
  final bool isLoading; // loading pop up
  final String currentPath;
  final String? selectedDbUrl;
  final bool? quit;
  DatabaseState({
    required this.selectedDbUrl,
    required this.isLoading,
    required this.currentPath,
    this.quit,
  });

  copyWith({
    bool? isLoading,
    String? currentPath,
    String? selectedDbUrl,
    bool? quit,
  }) => DatabaseState(
    isLoading: isLoading ?? this.isLoading,
    currentPath: currentPath ?? this.currentPath,
    selectedDbUrl: selectedDbUrl ?? this.selectedDbUrl,
    quit: quit,
  );
}

// loading Dbs
final class DatabaseUninitializedState extends DatabaseState {
  DatabaseUninitializedState({
    required super.isLoading,
    required super.currentPath,
    required super.selectedDbUrl,
    super.quit,
  });

  @override
  copyWith({
    bool? isLoading,
    String? currentPath,
    String? selectedDbUrl,
    bool? quit,
  }) => DatabaseUninitializedState(
    isLoading: isLoading ?? this.isLoading,
    currentPath: currentPath ?? this.currentPath,
    selectedDbUrl: selectedDbUrl ?? this.selectedDbUrl,
    quit: quit,
  );
}

// Dbs loaded
final class DatabaseInitializedState extends DatabaseState {
  final List<RemoteDatabase> dbs;
  final Iterable<DbData>? data;

  DatabaseInitializedState({
    required this.dbs,
    required this.data,
    required super.isLoading,
    required super.currentPath,
    required super.selectedDbUrl,
    super.quit,
  });

  @override
  copyWith({
    bool? isLoading,
    String? currentPath,
    List<RemoteDatabase>? dbs,
    Iterable<DbData>? data,
    String? selectedDbUrl,
    bool? quit,
  }) => DatabaseInitializedState(
    dbs: dbs ?? this.dbs,
    data: data ?? this.data,
    isLoading: isLoading ?? this.isLoading,
    currentPath: currentPath ?? this.currentPath,
    selectedDbUrl: selectedDbUrl ?? this.selectedDbUrl,
    quit: quit,
  );
}
