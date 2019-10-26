import 'dart:io';

import 'package:test/test.dart';
import 'package:yeedart/yeedart.dart';

import 'fake_command_sender.dart';

void main() {
  Device testDevice;

  setUp(() {
    testDevice = Device(
      address: InternetAddress.anyIPv4,
      port: 55443,
      commandSender: FakeCommandSender(),
    );
  });

  tearDown(() {
    testDevice.disconnect();
  });

  test('Should return props.', () async {
    final response = CommandResponse(
      id: 3,
      result: <dynamic>["on", "", 100],
      error: null,
    );

    expect(
      await testDevice.getProps(id: 3, parameters: ["power", "asdf", "bright"]),
      response,
    );
  });

  test('Should return success command response.', () async {
    final response = CommandResponse(
      id: 2,
      result: <dynamic>["ok"],
      error: null,
    );

    expect(
      await testDevice.turnOn(id: 2),
      response,
    );
  });

  test('Should return error command response', () async {
    final response = CommandResponse(
      id: 999,
      result: null,
      error: <String, dynamic>{"code": -1, "message": "unsupported method"},
    );

    expect(
      await testDevice.sendCommand(Command(999, "not_exists", <void>[])),
      response,
    );
  });
}
