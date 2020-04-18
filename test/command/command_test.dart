import 'dart:math';

import 'package:test/test.dart';
import 'package:yeedart/src/command/enum/adjust_action.dart';
import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/enum/adjust_property.dart';
import 'package:yeedart/src/command/enum/effect.dart';
import 'package:yeedart/src/scene/scene_class.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  group('Command', () {
    int id;
    final Random random = Random();

    setUp(() {
      id = random.nextInt(100);
    });

    test('getProp()', () {
      expect(
        Command.getProp(id: id, parameters: <String>['color']),
        Command(id, CommandMethods.getProp, <String>['color']),
      );
    });

    test('setColorTemperature()', () {
      expect(
        Command.setColorTemperature(
          id: id,
          colorTemperature: 6000,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.setCtAbx,
          <dynamic>[6000, Effect.smooth().value, 30],
        ),
      );
    });

    test('setRGB()', () {
      expect(
        Command.setRGB(
          id: id,
          rgb: 0,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.setRGB,
          <dynamic>[0, Effect.smooth().value, 30],
        ),
      );
    });

    test('setHSV()', () {
      expect(
        Command.setHSV(
          id: id,
          hue: 359,
          saturation: 100,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.setHSV,
          <dynamic>[359, 100, Effect.smooth().value, 30],
        ),
      );
    });

    test('setBrightness()', () {
      expect(
        Command.setBrightness(
          id: id,
          brightness: 95,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.setBright,
          <dynamic>[95, Effect.smooth().value, 30],
        ),
      );
    });

    test('setPower', () {
      expect(
        Command.setPower(
          id: id,
          power: 'on',
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.setPower,
          <dynamic>['on', Effect.smooth().value, 30],
        ),
      );

      expect(
        Command.setPower(
          id: id,
          power: 'off',
          effect: Effect.smooth().value,
          duration: 30,
          mode: 1,
        ),
        Command(
          id,
          CommandMethods.setPower,
          <dynamic>['off', Effect.smooth().value, 30, 1],
        ),
      );
    });

    test('toggle()', () {
      expect(
        Command.toggle(id: id),
        Command(id, CommandMethods.toggle, <void>[]),
      );
    });

    test('setDefault()', () {
      expect(
        Command.setDefault(id: id),
        Command(id, CommandMethods.setDefault, <void>[]),
      );
    });

    test('startColorFlow()', () {
      expect(
        Command.startColorFlow(
          id: id,
          count: 0,
          action: 2,
          flowExpression: '50,1,255,100',
        ),
        Command(id, CommandMethods.startCF, <dynamic>[0, 2, '50,1,255,100']),
      );
    });

    test('stopColorFlow()', () {
      expect(
        Command.stopColorFlow(id: id),
        Command(id, CommandMethods.stopCF, <void>[]),
      );
    });

    test('setScene()', () {
      final color = SceneClass.color().value;
      final hsv = SceneClass.hsv().value;
      final cf = SceneClass.colorFlow().value;
      final ct = SceneClass.colorTemperature().value;
      final adoff = SceneClass.autoDelayOff().value;

      expect(
        Command.setScene(id: id, cls: color, val1: 65280, val2: 70),
        Command(id, CommandMethods.setScene, <void>[color, 65280, 70]),
      );

      expect(
        Command.setScene(id: id, cls: hsv, val1: 300, val2: 70, val3: '100'),
        Command(id, CommandMethods.setScene, <void>[hsv, 300, 70, 100]),
      );

      expect(
        Command.setScene(id: id, cls: ct, val1: 5400, val2: 100),
        Command(id, CommandMethods.setScene, <void>[ct, 5400, 100]),
      );

      const colorFlow = '500,1,255,100,1000,1,16776960,70';
      expect(
        Command.setScene(id: id, cls: cf, val1: 0, val2: 0, val3: colorFlow),
        Command(id, CommandMethods.setScene, <void>[cf, 0, 0, colorFlow]),
      );

      expect(
        Command.setScene(id: id, cls: adoff, val1: 50, val2: 5),
        Command(id, CommandMethods.setScene, <void>[adoff, 50, 5]),
      );
    });

    test('cronAdd()', () {
      expect(
        Command.cronAdd(id: id, value: 10),
        Command(id, CommandMethods.cronAdd, <void>[0, 10]),
      );
    });

    test('cronGet()', () {
      expect(
        Command.cronGet(id: id),
        Command(id, CommandMethods.cronGet, <void>[0]),
      );
    });

    test('cronDelete()', () {
      expect(
        Command.cronDelete(id: id),
        Command(id, CommandMethods.cronDel, <void>[0]),
      );
    });

    test('setAdjust()', () {
      expect(
        Command.setAdjust(
          id: id,
          action: AdjustAction.increase().value,
          property: AdjustProperty.brightness().value,
        ),
        Command(
          id,
          CommandMethods.setAdjust,
          <void>[
            AdjustAction.increase().value,
            AdjustProperty.brightness().value
          ],
        ),
      );
    });

    test('setMusic()', () {
      expect(
        Command.setMusic(id: id, action: 0, host: '127.0.0.1', port: 1234),
        Command(id, CommandMethods.setMusic, <void>[0, '127.0.0.1', 1234]),
      );
    });

    test('setName()', () {
      expect(
        Command.setName(id: id, name: 'The name'),
        Command(id, CommandMethods.setName, <void>['The name']),
      );
    });

    test('bgSetRGB()', () {
      expect(
        Command.bgSetRGB(
          id: id,
          rgb: 0,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.bgSetRGB,
          <dynamic>[0, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgSetHSV()', () {
      expect(
        Command.bgSetHSV(
          id: id,
          hue: 359,
          saturation: 100,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.bgSetHSV,
          <dynamic>[359, 100, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgSetColorTemperature()', () {
      expect(
        Command.bgSetColorTemperature(
          id: id,
          colorTemperature: 6000,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.bgSetCtAbx,
          <dynamic>[6000, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgStartColorFlow()', () {
      expect(
        Command.bgStartColorFlow(
          id: id,
          count: 0,
          action: 2,
          flowExpression: '50,1,255,100',
        ),
        Command(id, CommandMethods.bgStartCF, <dynamic>[0, 2, '50,1,255,100']),
      );
    });

    test('bgStopColorFlow()', () {
      expect(
        Command.bgStopColorFlow(id: id),
        Command(id, CommandMethods.bgStopCF, <void>[]),
      );
    });

    test('bgSetScene()', () {
      final color = SceneClass.color().value;
      final hsv = SceneClass.hsv().value;
      final cf = SceneClass.colorFlow().value;
      final ct = SceneClass.colorTemperature().value;
      final adoff = SceneClass.autoDelayOff().value;

      expect(
        Command.bgSetScene(id: id, cls: color, val1: 65280, val2: 70),
        Command(id, CommandMethods.bgSetScene, <void>[color, 65280, 70]),
      );

      expect(
        Command.bgSetScene(id: id, cls: hsv, val1: 300, val2: 70, val3: '100'),
        Command(id, CommandMethods.bgSetScene, <void>[hsv, 300, 70, 100]),
      );

      expect(
        Command.bgSetScene(id: id, cls: ct, val1: 5400, val2: 100),
        Command(id, CommandMethods.bgSetScene, <void>[ct, 5400, 100]),
      );

      const colorFlow = '500,1,255,100,1000,1,16776960,70';
      expect(
        Command.bgSetScene(id: id, cls: cf, val1: 0, val2: 0, val3: colorFlow),
        Command(id, CommandMethods.bgSetScene, <void>[cf, 0, 0, colorFlow]),
      );

      expect(
        Command.bgSetScene(id: id, cls: adoff, val1: 50, val2: 5),
        Command(id, CommandMethods.bgSetScene, <void>[adoff, 50, 5]),
      );
    });

    test('bgSetDefault()', () {
      expect(
        Command.bgSetDefault(id: id),
        Command(id, CommandMethods.bgSetDefault, <void>[]),
      );
    });

    test('bgSetPower', () {
      expect(
        Command.bgSetPower(
          id: id,
          power: 'on',
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.bgSetPower,
          <dynamic>['on', Effect.smooth().value, 30],
        ),
      );

      expect(
        Command.bgSetPower(
          id: id,
          power: 'off',
          effect: Effect.smooth().value,
          duration: 30,
          mode: 1,
        ),
        Command(
          id,
          CommandMethods.bgSetPower,
          <dynamic>['off', Effect.smooth().value, 30, 1],
        ),
      );
    });

    test('bgSetBrightness()', () {
      expect(
        Command.bgSetBrightness(
          id: id,
          brightness: 95,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          id,
          CommandMethods.bgSetBright,
          <dynamic>[95, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgSetAdjust()', () {
      expect(
        Command.bgSetAdjust(
          id: id,
          action: AdjustAction.increase().value,
          property: AdjustProperty.brightness().value,
        ),
        Command(
          id,
          CommandMethods.bgSetAdjust,
          <void>[
            AdjustAction.increase().value,
            AdjustProperty.brightness().value
          ],
        ),
      );
    });

    test('bgToggle()', () {
      expect(
        Command.bgToggle(id: id),
        Command(id, CommandMethods.bgToggle, <void>[]),
      );
    });

    test('devToggle()', () {
      expect(
        Command.devToggle(id: id),
        Command(id, CommandMethods.devToggle, <void>[]),
      );
    });

    test('adjustBrightness()', () {
      expect(
        Command.adjustBrightness(id: id, percentage: -50, duration: 30),
        Command(id, CommandMethods.adjustBright, <int>[-50, 30]),
      );
    });

    test('adjustColorTemperature()', () {
      expect(
        Command.adjustColorTemperature(id: id, percentage: 50, duration: 30),
        Command(id, CommandMethods.adjustCT, <int>[50, 30]),
      );
    });

    test('adjustColor()', () {
      expect(
        Command.adjustColor(id: id, percentage: 100, duration: 30),
        Command(id, CommandMethods.adjustColor, <int>[100, 30]),
      );
    });

    test('bgAdjustBrightness()', () {
      expect(
        Command.bgAdjustBrightness(id: id, percentage: 100, duration: 60),
        Command(id, CommandMethods.bgAdjustBright, <int>[100, 60]),
      );
    });

    test('bgAdjustColorTemperature()', () {
      expect(
        Command.bgAdjustColorTemperature(id: id, percentage: 70, duration: 60),
        Command(id, CommandMethods.bgAdjustCT, <int>[70, 60]),
      );
    });

    test('bgAdjustColor()', () {
      expect(
        Command.bgAdjustColor(id: id, percentage: -7, duration: 160),
        Command(id, CommandMethods.bgAdjustColor, <int>[-7, 160]),
      );
    });

    test('toString() returns correct value', () {
      final command = Command.adjustColor(percentage: 100, duration: 30);
      expect(command.toString(), 'Command: ${command.message}');
    });
  });

  group('CommandMethods', () {
    test('methodExists() returns whether command method exist or not', () {
      expect(CommandMethods.methodExists(CommandMethods.adjustColor), true);
      expect(CommandMethods.methodExists('some_random_method'), false);
    });
  });
}
