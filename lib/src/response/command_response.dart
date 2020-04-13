import 'dart:convert';

import 'package:meta/meta.dart';

/// Response to [Command].
class CommandResponse {
  /// Same as sent id of the sent command.
  final int id;

  /// If command is successfully executed, result will be returned.
  final List<dynamic> result;

  /// If command fails, error will be returned.
  final Map<String, dynamic> error;

  CommandResponse({
    @required this.id,
    this.result,
    this.error,
  });

  /// Creates [CommandResponse] from parsed JSON.
  CommandResponse.fromJson(Map<String, dynamic> parsed)
      : id = parsed['id'] as int,
        result = parsed['result'] as List,
        error = parsed['error'] as Map<String, dynamic>;

  /// Indicates whether command was successfully executed or not.
  bool get hasError => error != null;

  /// Returns raw response (as string).
  String get raw => _toJson();

  String _toJson() {
    return hasError
        ? json.encode(<String, dynamic>{
            'id': id,
            'error': error,
          })
        : json.encode(<String, dynamic>{
            'id': id,
            'result': result,
          });
  }

  @override
  int get hashCode => id.hashCode ^ result.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CommandResponse &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            result.toString() == other.result.toString();
  }

  @override
  String toString() => 'CommandResponse: $raw';
}
