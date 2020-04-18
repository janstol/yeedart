import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:yeedart/src/response/notification_message.dart';

import '../fixtures/fixtures.dart';

void main() {
  final json = Fixtures.loadJson('notification_message.json');

  test('should parse json message', () {
    expect(
      NotificationMessage.fromJson(json),
      NotificationMessage(
        method: json['method'] as String,
        params: json['params'] as Map<String, dynamic>,
      ),
    );
  });

  test('hashCode returns correct value', () {
    final message = NotificationMessage.fromJson(json);
    const _mapEquality = MapEquality<String, dynamic>();

    expect(
      message.hashCode,
      message.method.hashCode ^
          message.runtimeType.hashCode ^
          _mapEquality.hash(message.params),
    );
  });

  test('toString returns correct value', () {
    final message = NotificationMessage.fromJson(json);
    expect(message.toString(), 'NotificationMessage(${message.raw})');
  });
}
