import 'dart:convert';

import 'package:collection/collection.dart';

/// [Device] sends a [NotificationMessage] to all connected clients
/// when there is a state change, to make sure all clients will get the latest
/// device state without having to poll the state from time to time.
///
/// See [Device.onNotificationReceived].
class NotificationMessage {
  /// Currently can be only 'props'.
  final String method;

  /// Contains params (keys) that has changed with actual value (values).
  final Map<String, dynamic> params;

  const NotificationMessage({this.method, this.params});

  /// Creates [NotificationMessage] from JSON.
  NotificationMessage.fromJson(Map<String, dynamic> parsed)
      : method = parsed['method'] as String,
        params = parsed['params'] as Map<String, dynamic>;

  /// Returns raw message (as string).
  String get raw =>
      json.encode(<String, dynamic>{'method': method, 'params': params});

  static const _mapEquality = MapEquality<String, dynamic>();

  @override
  int get hashCode => method.hashCode ^ _mapEquality.hash(params);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NotificationMessage &&
            runtimeType == other.runtimeType &&
            method == other.method &&
            _mapEquality.equals(params, other.params);
  }

  @override
  String toString() => 'NotificationMessage($raw)';
}
