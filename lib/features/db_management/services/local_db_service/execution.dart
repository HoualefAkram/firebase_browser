class SqfliteExec {
  static const String databasesTableName = "remoteDb";
  static const String dbName = "databases.db";
  static const int version = 1;

  static final String createDB = """CREATE TABLE $databasesTableName(
  url TEXT PRIMARY KEY,
  name TEXT NOT NULL)""";
}
