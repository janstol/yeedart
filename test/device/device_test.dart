import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';
import 'package:yeedart/src/response/notification_message.dart';
import 'package:yeedart/yeedart.dart';

import '../mocks/fake_command_sender.dart';

void main() {
  late Device testDevice;
  final Random random = Random();
  late int id;

  setUp(() {
    id = random.nextInt(100);
    testDevice = Device(
      address: InternetAddress.anyIPv4,
      port: 55443,
      commandSender: FakeCommandSender(),
    );
  });

  tearDown(() {
    if ((testDevice.commandSender as FakeCommandSender).isConnected) {
      testDevice.disconnect();
    }
  });

  test('getProps()', () async {
    expect(
      await testDevice
          .getProps(id: id, parameters: ['power', 'asdf', 'bright']),
      CommandResponse(id: id, result: <dynamic>['on', '', 100], error: null),
    );
  });

  test('setColorTemperature()', () async {
    const effect = Effect.smooth();
    const duration = Duration(milliseconds: 30);

    expect(
      await testDevice.setColorTemperature(
        id: id,
        lightType: LightType.main,
        colorTemperature: 6500,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.setColorTemperature(
        id: id,
        lightType: LightType.backgroud,
        colorTemperature: 6500,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.setColorTemperature(
        id: id,
        lightType: LightType.both,
        colorTemperature: 6500,
        effect: effect,
        duration: duration,
      ),
      throwsArgumentError,
    );
  });

  test('setRGB()', () async {
    const effect = Effect.smooth();
    const duration = Duration(milliseconds: 30);

    expect(
      await testDevice.setRGB(
        id: id,
        lightType: LightType.main,
        color: 255,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.setRGB(
        id: id,
        lightType: LightType.backgroud,
        color: 250,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.setRGB(
        id: id,
        lightType: LightType.both,
        color: 250,
        effect: effect,
        duration: duration,
      ),
      throwsArgumentError,
    );
  });

  test('setHSV()', () async {
    const effect = Effect.smooth();
    const duration = Duration(milliseconds: 30);

    expect(
      await testDevice.setHSV(
        id: id,
        lightType: LightType.main,
        hue: 255,
        saturation: 45,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.setHSV(
        id: id,
        lightType: LightType.backgroud,
        hue: 255,
        saturation: 45,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.setHSV(
        id: id,
        lightType: LightType.both,
        hue: 255,
        saturation: 45,
        effect: effect,
        duration: duration,
      ),
      throwsArgumentError,
    );
  });

  test('setBrightness()', () async {
    const effect = Effect.smooth();
    const duration = Duration(milliseconds: 30);

    expect(
      await testDevice.setBrightness(
        id: id,
        lightType: LightType.main,
        brightness: 75,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.setBrightness(
        id: id,
        lightType: LightType.backgroud,
        brightness: 75,
        effect: effect,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.setBrightness(
        id: id,
        lightType: LightType.both,
        brightness: 75,
        effect: effect,
        duration: duration,
      ),
      throwsArgumentError,
    );
  });

  test('turnOn()', () async {
    const effect = Effect.smooth();
    const duration = Duration(milliseconds: 30);

    expect(
      await testDevice.turnOn(id: id, effect: effect, duration: duration),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );
  });

  test('turnOff()', () async {
    const effect = Effect.smooth();
    const duration = Duration(milliseconds: 30);

    expect(
      await testDevice.turnOff(id: id, effect: effect, duration: duration),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );
  });

  test('toggle()', () async {
    expect(
      await testDevice.toggle(id: id, lightType: LightType.main),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.toggle(id: id, lightType: LightType.backgroud),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.toggle(id: id, lightType: LightType.both),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );
  });

  test('setDefault()', () async {
    expect(
      await testDevice.setDefault(id: id, lightType: LightType.main),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.setDefault(id: id, lightType: LightType.backgroud),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.setDefault(id: id, lightType: LightType.both),
      throwsArgumentError,
    );
  });

  test('startFlow()', () async {
    final flow = Flow.rgb();

    expect(
      await testDevice.startFlow(id: id, lightType: LightType.main, flow: flow),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.startFlow(
          id: id, lightType: LightType.backgroud, flow: flow),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.startFlow(id: id, lightType: LightType.both, flow: flow),
      throwsArgumentError,
    );
  });

  test('stopFlow()', () async {
    expect(
      await testDevice.stopFlow(id: id, lightType: LightType.main),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.stopFlow(id: id, lightType: LightType.backgroud),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.stopFlow(id: id, lightType: LightType.both),
      throwsArgumentError,
    );
  });

  test('setScene()', () async {
    const scene = Scene.color(color: 250, brightness: 100);

    expect(
      await testDevice.setScene(
        id: id,
        lightType: LightType.main,
        scene: scene,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.setScene(
        id: id,
        lightType: LightType.backgroud,
        scene: scene,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.setScene(id: id, lightType: LightType.both, scene: scene),
      throwsArgumentError,
    );
  });

  test('cronAdd()', () async {
    expect(
      await testDevice.cronAdd(id: id, timer: const Duration(hours: 1)),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );
  });

  test('cronGet()', () async {
    expect(
      await testDevice.cronGet(id: id),
      CommandResponse(
        id: id,
        result: <dynamic>[
          {'type': 0, 'delay': 15, 'mix': 0}
        ],
        error: null,
      ),
    );
  });

  test('cronDelete()', () async {
    expect(
      await testDevice.cronDelete(id: id),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );
  });

  test('setAdjust()', () async {
    const action = AdjustAction.increase();
    const property = AdjustProperty.brightness();

    expect(
      await testDevice.setAdjust(
        id: id,
        lightType: LightType.main,
        action: action,
        property: property,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.setAdjust(
        id: id,
        lightType: LightType.backgroud,
        action: action,
        property: property,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.setAdjust(
        id: id,
        lightType: LightType.both,
        action: action,
        property: property,
      ),
      throwsArgumentError,
    );
  });

  test('setMusic()', () async {
    expect(
      await testDevice.setMusic(
        id: id,
        action: 1,
        host: '127.0.0.1',
        port: 1234,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );
  });

  test('setName()', () async {
    expect(
      await testDevice.setName(id: id, name: 'Bulb'),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );
  });

  test('adjustBrightness()', () async {
    const duration = Duration(seconds: 20);

    expect(
      await testDevice.adjustBrightness(
        id: id,
        lightType: LightType.main,
        percentage: 20,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.adjustBrightness(
        id: id,
        lightType: LightType.backgroud,
        percentage: 50,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.adjustBrightness(
        id: id,
        lightType: LightType.both,
        percentage: 10,
        duration: duration,
      ),
      throwsArgumentError,
    );
  });

  test('adjustColorTemperature()', () async {
    const duration = Duration(seconds: 20);

    expect(
      await testDevice.adjustColorTemperature(
        id: id,
        lightType: LightType.main,
        percentage: 20,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.adjustColorTemperature(
          id: id,
          lightType: LightType.backgroud,
          percentage: 50,
          duration: duration),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.adjustColorTemperature(
        id: id,
        lightType: LightType.both,
        percentage: 10,
        duration: duration,
      ),
      throwsArgumentError,
    );
  });

  test('adjustColor()', () async {
    const duration = Duration(seconds: 20);

    expect(
      await testDevice.adjustColor(
        id: id,
        lightType: LightType.main,
        percentage: 20,
        duration: duration,
      ),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      await testDevice.adjustColor(
          id: id,
          lightType: LightType.backgroud,
          percentage: 50,
          duration: duration),
      CommandResponse(id: id, result: <dynamic>['ok'], error: null),
    );

    expect(
      testDevice.adjustColor(
        id: id,
        lightType: LightType.both,
        percentage: 10,
        duration: duration,
      ),
      throwsArgumentError,
    );
  });

  test('Should return error command response', () async {
    expect(
      await testDevice.sendCommand(Command(999, 'not_exists', <void>[])),
      CommandResponse(
        id: 999,
        result: null,
        error: <String, dynamic>{'code': -1, 'message': 'unsupported method'},
      ),
    );
  });

  test('notificationMessageStream emits notification messages', () async {
    await testDevice.turnOn();

    expectLater(
      testDevice.notificationMessageStream,
      emitsInOrder(<NotificationMessage>[
        const NotificationMessage(params: <String, dynamic>{'bright': '100'}),
        const NotificationMessage(params: <String, dynamic>{'bright': '20'}),
        const NotificationMessage(method: null, params: null),
        const NotificationMessage(params: <String, dynamic>{'bright': '50'}),
      ]),
    );

    await testDevice.setBrightness(brightness: 100);
    await testDevice.setBrightness(brightness: 20);
    await testDevice.sendCommand(Command(999, 'not_exists', <void>[]));
    await testDevice.setBrightness(brightness: 50);
  });

  test('connect and disconnect', () async {
    expect(testDevice.isConnected, false);
    await testDevice.connect();
    expect(testDevice.isConnected, true);
    testDevice.disconnect();
    expect(testDevice.isConnected, false);
  });

  test('isConnected - device should be disconnected by default', () async {
    expect(testDevice.isConnected, false);
    await testDevice.turnOn();
    expect(testDevice.isConnected, true);
    testDevice.disconnect();
    expect(testDevice.isConnected, false);
  });

  test('device equality', () {
    final device = Device(
      address: InternetAddress.loopbackIPv4,
      port: 55443,
      commandSender: FakeCommandSender()..connect(),
    );

    expect(
      device,
      Device(
        address: InternetAddress.loopbackIPv4,
        port: 55443,
        commandSender: FakeCommandSender()..connect(),
      ),
    );
  });

  test('hashCode returns correct value', () {
    final device = Device(
      address: InternetAddress.loopbackIPv4,
      port: 55443,
      commandSender: FakeCommandSender(),
    );
    expect(
      device.hashCode,
      device.address.hashCode ^
          device.port.hashCode ^
          device.runtimeType.hashCode,
    );
  });

  test('toString returns correct value', () {
    final device = Device(
      address: InternetAddress.loopbackIPv4,
      port: 55443,
      commandSender: FakeCommandSender(),
    );

    expect(
      device.toString(),
      'Device(address: ${device.address}, port: ${device.port})',
    );
  });
}
