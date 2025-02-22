class AppException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  AppException({required this.message, this.error, this.stackTrace});

  @override
  String toString() {
    return message;
  }
}
