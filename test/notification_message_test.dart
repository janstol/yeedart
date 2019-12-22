import 'dart:convert';

import 'package:test/test.dart';
import 'package:yeedart/src/response/notification_message.dart';

import 'fixtures/fixtures.dart';

void main() {
  test('Should return notification message.', () {
    final messageRaw = fixture('notification_message.json');
    const message = NotificationMessage(
      method: 'props',
      params: <String, dynamic>{
        'power': 'on',
        'bright': '10',
      },
    );

    final parsed = json.decode(messageRaw) as Map<String, dynamic>;

    expect(NotificationMessage.fromJson(parsed), message);
  });
}
