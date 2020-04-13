import 'package:test/test.dart';
import 'package:yeedart/src/command/enum/adjust_action.dart';
import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/enum/adjust_property.dart';
import 'package:yeedart/src/command/enum/effect.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  group('Command', () {
    test('getProp()', () {
      expect(
        Command.getProp(id: 1, parameters: <String>['color']),
        Command(1, CommandMethods.getProp, <String>['color']),
      );
    });

    test('setColorTemperature()', () {
      expect(
        Command.setColorTemperature(
          id: 1,
          colorTemperature: 6000,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          1,
          CommandMethods.setCtAbx,
          <dynamic>[6000, Effect.smooth().value, 30],
        ),
      );
    });

    test('setRGB()', () {
      expect(
        Command.setRGB(
          id: 2,
          rgb: 0,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          2,
          CommandMethods.setRGB,
          <dynamic>[0, Effect.smooth().value, 30],
        ),
      );
    });

    test('setHSV()', () {
      expect(
        Command.setHSV(
          id: 3,
          hue: 359,
          saturation: 100,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          3,
          CommandMethods.setHSV,
          <dynamic>[359, 100, Effect.smooth().value, 30],
        ),
      );
    });

    test('setBrightness()', () {
      expect(
        Command.setBrightness(
          id: 4,
          brightness: 95,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          4,
          CommandMethods.setBright,
          <dynamic>[95, Effect.smooth().value, 30],
        ),
      );
    });

    test('setPower', () {
      expect(
        Command.setPower(
          id: 5,
          power: 'on',
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          5,
          CommandMethods.setPower,
          <dynamic>['on', Effect.smooth().value, 30],
        ),
      );

      expect(
        Command.setPower(
          id: 6,
          power: 'off',
          effect: Effect.smooth().value,
          duration: 30,
          mode: 1,
        ),
        Command(
          6,
          CommandMethods.setPower,
          <dynamic>['off', Effect.smooth().value, 30, 1],
        ),
      );
    });

    test('toggle()', () {
      expect(
        Command.toggle(id: 7),
        Command(7, CommandMethods.toggle, <void>[]),
      );
    });

    test('setDefault()', () {
      expect(
        Command.setDefault(id: 8),
        Command(8, CommandMethods.setDefault, <void>[]),
      );
    });

    test('startColorFlow()', () {
      expect(
        Command.startColorFlow(
          id: 9,
          count: 0,
          action: 2,
          flowExpression: '50,1,255,100',
        ),
        Command(9, CommandMethods.startCF, <dynamic>[0, 2, '50,1,255,100']),
      );
    });

    test('stopColorFlow()', () {
      expect(
        Command.stopColorFlow(id: 10),
        Command(10, CommandMethods.stopCF, <void>[]),
      );
    });

    test('setScene()', () {
      expect(
        Command.setScene(id: 11, cls: 'color', val1: 255, val2: 100),
        Command(11, CommandMethods.setScene, <void>['color', 255, 100]),
      );
      expect(
        Command.setScene(
          id: 12,
          cls: 'cf',
          val1: 0,
          val2: 0,
          val3: '500,1,255,100,1000,1,16776960,70',
        ),
        Command(
          12,
          CommandMethods.setScene,
          <void>['cf', 0, 0, '500,1,255,100,1000,1,16776960,70'],
        ),
      );
    });

    test('cronAdd()', () {
      expect(
        Command.cronAdd(id: 13, value: 10),
        Command(13, CommandMethods.cronAdd, <void>[0, 10]),
      );
    });

    test('cronGet()', () {
      expect(
        Command.cronGet(id: 14),
        Command(14, CommandMethods.cronGet, <void>[0]),
      );
    });

    test('cronDelete()', () {
      expect(
        Command.cronDelete(id: 15),
        Command(15, CommandMethods.cronDel, <void>[0]),
      );
    });

    test('setAdjust()', () {
      expect(
        Command.setAdjust(
          id: 16,
          action: AdjustAction.increase().value,
          property: AdjustProperty.brightness().value,
        ),
        Command(
          16,
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
        Command.setMusic(id: 17, action: 0, host: '127.0.0.1', port: 1234),
        Command(17, CommandMethods.setMusic, <void>[0, '127.0.0.1', 1234]),
      );
    });

    test('setName()', () {
      expect(
        Command.setName(id: 18, name: 'The name'),
        Command(18, CommandMethods.setName, <void>['The name']),
      );
    });

    test('bgSetRGB()', () {
      expect(
        Command.bgSetRGB(
          id: 19,
          rgb: 0,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          19,
          CommandMethods.bgSetRGB,
          <dynamic>[0, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgSetHSV()', () {
      expect(
        Command.bgSetHSV(
          id: 20,
          hue: 359,
          saturation: 100,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          20,
          CommandMethods.bgSetHSV,
          <dynamic>[359, 100, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgSetColorTemperature()', () {
      expect(
        Command.bgSetColorTemperature(
          id: 21,
          colorTemperature: 6000,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          21,
          CommandMethods.bgSetCtAbx,
          <dynamic>[6000, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgStartColorFlow()', () {
      expect(
        Command.bgStartColorFlow(
          id: 22,
          count: 0,
          action: 2,
          flowExpression: '50,1,255,100',
        ),
        Command(22, CommandMethods.bgStartCF, <dynamic>[0, 2, '50,1,255,100']),
      );
    });

    test('bgStopColorFlow()', () {
      expect(
        Command.bgStopColorFlow(id: 23),
        Command(23, CommandMethods.bgStopCF, <void>[]),
      );
    });

    test('bgSetScene()', () {
      expect(
        Command.bgSetScene(id: 24, cls: 'color', val1: 255, val2: 100),
        Command(24, CommandMethods.bgSetScene, <void>['color', 255, 100]),
      );
      expect(
        Command.bgSetScene(
          id: 25,
          cls: 'cf',
          val1: 0,
          val2: 0,
          val3: '500,1,255,100,1000,1,16776960,70',
        ),
        Command(
          25,
          CommandMethods.bgSetScene,
          <void>['cf', 0, 0, '500,1,255,100,1000,1,16776960,70'],
        ),
      );
    });

    test('bgSetDefault()', () {
      expect(
        Command.bgSetDefault(id: 26),
        Command(26, CommandMethods.bgSetDefault, <void>[]),
      );
    });

    test('bgSetPower', () {
      expect(
        Command.bgSetPower(
          id: 27,
          power: 'on',
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          27,
          CommandMethods.bgSetPower,
          <dynamic>['on', Effect.smooth().value, 30],
        ),
      );

      expect(
        Command.bgSetPower(
          id: 28,
          power: 'off',
          effect: Effect.smooth().value,
          duration: 30,
          mode: 1,
        ),
        Command(
          28,
          CommandMethods.bgSetPower,
          <dynamic>['off', Effect.smooth().value, 30, 1],
        ),
      );
    });

    test('bgSetBrightness()', () {
      expect(
        Command.bgSetBrightness(
          id: 29,
          brightness: 95,
          effect: Effect.smooth().value,
          duration: 30,
        ),
        Command(
          29,
          CommandMethods.bgSetBright,
          <dynamic>[95, Effect.smooth().value, 30],
        ),
      );
    });

    test('bgSetAdjust()', () {
      expect(
        Command.bgSetAdjust(
          id: 30,
          action: AdjustAction.increase().value,
          property: AdjustProperty.brightness().value,
        ),
        Command(
          30,
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
        Command.bgToggle(id: 31),
        Command(31, CommandMethods.bgToggle, <void>[]),
      );
    });

    test('devToggle()', () {
      expect(
        Command.devToggle(id: 32),
        Command(32, CommandMethods.devToggle, <void>[]),
      );
    });

    test('adjustBrightness()', () {
      expect(
        Command.adjustBrightness(id: 33, percentage: -50, duration: 30),
        Command(33, CommandMethods.adjustBright, <int>[-50, 30]),
      );
    });

    test('adjustColorTemperature()', () {
      expect(
        Command.adjustColorTemperature(id: 34, percentage: 50, duration: 30),
        Command(34, CommandMethods.adjustCT, <int>[50, 30]),
      );
    });

    test('adjustColor()', () {
      expect(
        Command.adjustColor(id: 35, percentage: 100, duration: 30),
        Command(35, CommandMethods.adjustColor, <int>[100, 30]),
      );
    });

    test('bgAdjustBrightness()', () {
      expect(
        Command.bgAdjustBrightness(id: 36, percentage: 100, duration: 60),
        Command(36, CommandMethods.bgAdjustBright, <int>[100, 60]),
      );
    });

    test('bgAdjustColorTemperature()', () {
      expect(
        Command.bgAdjustColorTemperature(id: 37, percentage: 70, duration: 60),
        Command(37, CommandMethods.bgAdjustCT, <int>[70, 60]),
      );
    });

    test('bgAdjustColor()', () {
      expect(
        Command.bgAdjustColor(id: 38, percentage: -7, duration: 160),
        Command(38, CommandMethods.bgAdjustColor, <int>[-7, 160]),
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
