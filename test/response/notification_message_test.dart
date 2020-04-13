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

  test('toString returns correct value', () {
    final message = NotificationMessage.fromJson(json);
    expect(message.toString(), 'NotificationMessage(${message.raw})');
  });
}
