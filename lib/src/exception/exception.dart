/// Generic Yeelight exception.
abstract class YeelightException implements Exception {}

/// Exception thrown when TCP connection to device has failed.
class YeelightConnectionException implements YeelightException {
  final String message;

  const YeelightConnectionException(this.message);

  @override
  int get hashCode => message.hashCode ^ runtimeType.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is YeelightConnectionException &&
            message == other.message &&
            runtimeType == other.runtimeType;
  }

  @override
  String toString() => 'YeelightConnectionException: $message';
}
