/// Generic Yeelight exception.
abstract class YeeException implements Exception {
  @override
  String toString() => "YeelightException";
}

/// Exception thrown when TCP connection to device has failed.
class YeeConnectionException implements YeeException {
  final String message;

  const YeeConnectionException(this.message);

  @override
  String toString() => "YeelightConnectionException: $message";
}
