class DbHttpException implements Exception {
  final int statusCode;
  final String body;

  DbHttpException({required this.statusCode, required this.body});

  @override
  String toString() => "DbHttpException(statusCode: $statusCode, body: $body)";
}
