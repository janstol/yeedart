/// Generic Yeelight exception.
abstract class YeelightException implements Exception {
  @override
  String toString() => "YeelightException";
}

/// Exception thrown when TCP connection to device has failed.
class YeelightConnectionException implements YeelightException {
  final String message;

  const YeelightConnectionException(this.message);

  @override
  String toString() => "YeelightConnectionException: $message";
}
