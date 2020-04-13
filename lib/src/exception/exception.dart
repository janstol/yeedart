/// Generic Yeelight exception.
abstract class YeelightException implements Exception {
  @override
  String toString() => 'YeelightException';
}

/// Exception thrown when TCP connection to device has failed.
class YeelightConnectionException implements YeelightException {
  final String message;

  const YeelightConnectionException(this.message);

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is YeelightConnectionException && message == other.message;
  }

  @override
  String toString() => 'YeelightConnectionException: $message';
}
