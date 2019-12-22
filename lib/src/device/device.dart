import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yeedart/src/command/adjust_action.dart';
import 'package:yeedart/src/command/adjust_property.dart';
import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/command_sender.dart';
import 'package:yeedart/src/command/effect.dart';
import 'package:yeedart/src/command/tcp_command_sender.dart';
import 'package:yeedart/src/device/light_type.dart';
import 'package:yeedart/src/flow/flow.dart';
import 'package:yeedart/src/response/command_response.dart';
import 'package:yeedart/src/response/notification_message.dart';
import 'package:yeedart/src/scene/scene.dart';

/// Represents Yeelight device (bulb, light, strip,...) and allows to control
/// device with given [address] and [port].
class Device {
  /// IP address of the device.
  final InternetAddress address;

  /// Port of the device.
  final int port;

  /// Command sender, default is [TCPCommandSender].
  CommandSender commandSender;

  Device({
    @required this.address,
    @required this.port,
    this.commandSender,
  }) {
    commandSender ??= TCPCommandSender(address: address, port: port);
  }

  /// This method is used to retrieve current property of the device.
  ///
  /// * [parameters] - a list of property names and the response contains
  /// a list of corresponding property values. If the requested property name is
  /// not recognized by device, then an empty string value will be returned.
  ///
  /// **Example**:
  /// ```dart
  /// device.getProps(parameters: ['power', 'not_exists', 'bright']);
  /// ```
  Future<CommandResponse> getProps({
    int id,
    @required List<String> parameters,
  }) async {
    return commandSender.sendCommand(
      Command.getProp(id: id, parameters: parameters),
    );
  }

  /// This method is used to set the color temperature of the light.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [colorTemperature] - target color temperature (1700 - 6500 K).
  /// * [effect]
  ///   * [Effect.sudden] - parameter [duration] is ignored in this case.
  ///   * or [Effect.smooth] - Length of this change is specified by [duration].
  /// * [duration] - the duration of the effect. The minimum is
  /// 30 milliseconds. Ignored for [Effect.sudden].
  ///
  /// **Example**:
  /// ```dart
  /// device.setColorTemperature(
  ///   colorTemperature: ColorTemperature(1700),
  ///   effect: Effect.sudden(),
  ///   duration: Duration(milliseconds: 500),
  /// );
  /// ```
  /// This command is accepted only if the device is in 'ON' state.
  Future<CommandResponse> setColorTemperature({
    int id,
    LightType lightType = LightType.main,
    @required int colorTemperature,
    Effect effect = const Effect.smooth(),
    Duration duration = const Duration(milliseconds: 30),
  }) async {
    final cmd = lightType == LightType.main
        ? Command.setColorTemperature(
            id: id,
            colorTemperature: colorTemperature,
            effect: effect.value,
            duration: duration.inMilliseconds,
          )
        : Command.bgSetColorTemperature(
            id: id,
            colorTemperature: colorTemperature,
            effect: effect.value,
            duration: duration.inMilliseconds,
          );

    return commandSender.sendCommand(cmd);
  }

  /// This method is used to set the color of light.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [color] - target color (for example: 0xffffff).
  /// * [effect]
  ///   * [Effect.sudden] - parameter [duration] is ignored in this case.
  ///   * or [Effect.smooth] - Length of this change is specified by [duration].
  /// * [duration] - the duration of the effect. The minimum is
  /// 30 milliseconds. Ignored for [Effect.sudden].
  ///
  /// **Example**:
  /// ```dart
  /// device.setRGB(
  ///   color: Colors.red,
  ///   effect: Effect.sudden(),
  ///   duration: Duration(milliseconds: 500),
  /// );
  /// ```
  /// This command is accepted only if the device is in 'ON' state.
  Future<CommandResponse> setRGB({
    int id,
    LightType lightType = LightType.main,
    @required int color,
    Effect effect = const Effect.smooth(),
    Duration duration = const Duration(milliseconds: 30),
  }) async {
    final cmd = lightType == LightType.main
        ? Command.setRGB(
            id: id,
            rgb: color,
            effect: effect.value,
            duration: duration.inMilliseconds,
          )
        : Command.bgSetRGB(
            id: id,
            rgb: color,
            effect: effect.value,
            duration: duration.inMilliseconds,
          );

    return commandSender.sendCommand(cmd);
  }

  /// This method is used to set the color of light.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [hue] and [saturation] - target color.
  /// * [effect]
  ///   * [Effect.sudden] - parameter [duration] is ignored in this case.
  ///   * or [Effect.smooth] - Length of this change is specified by [duration].
  /// * [duration] - the duration of the effect. The minimum is
  /// 30 milliseconds. Ignored for [Effect.sudden].
  ///
  /// **Example**:
  /// ```dart
  /// device.setHSV(
  ///   hue: 255,
  ///   saturation: 45,
  ///   effect: Effect.sudden(),
  ///   duration: Duration(milliseconds: 500),
  /// );
  /// ```
  /// This command is accepted only if the device is in 'ON' state.
  Future<CommandResponse> setHSV({
    int id,
    LightType lightType = LightType.main,
    @required int hue,
    @required int saturation,
    Effect effect = const Effect.smooth(),
    Duration duration = const Duration(milliseconds: 30),
  }) async {
    final cmd = lightType == LightType.main
        ? Command.setHSV(
            id: id,
            hue: hue,
            saturation: saturation,
            effect: effect.value,
            duration: duration.inMilliseconds,
          )
        : Command.bgSetHSV(
            id: id,
            hue: hue,
            saturation: saturation,
            effect: effect.value,
            duration: duration.inMilliseconds,
          );
    return commandSender.sendCommand(cmd);
  }

  /// This method is used to change the brightness of light.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [brightness] - target brightness (1-100).
  /// * [effect]
  ///   * [Effect.sudden] - parameter [duration] is ignored in this case.
  ///   * or [Effect.smooth] - Length of this change is specified by [duration].
  /// * [duration] - the duration of the effect. The minimum is
  /// 30 milliseconds. Ignored for [Effect.sudden].
  ///
  /// **Example**:
  /// ```dart
  /// device.setBrightness(
  ///   brightness: 50,
  ///   effect: Effect.sudden(),
  ///   duration: Duration(milliseconds: 300),
  /// );
  /// ```
  /// This command is accepted only if the device is in 'ON' state.
  Future<CommandResponse> setBrightness({
    int id,
    LightType lightType = LightType.main,
    @required int brightness,
    Effect effect = const Effect.smooth(),
    Duration duration = const Duration(milliseconds: 30),
  }) async {
    final cmd = lightType == LightType.main
        ? Command.setBrightness(
            id: id,
            brightness: brightness,
            effect: effect.value,
            duration: duration.inMilliseconds,
          )
        : Command.bgSetBrightness(
            id: id,
            brightness: brightness,
            effect: effect.value,
            duration: duration.inMilliseconds,
          );
    return commandSender.sendCommand(cmd);
  }

  /// This method is used to turn the device **ON**.
  ///
  /// * [effect]
  ///   * [Effect.sudden] - parameter [duration] is ignored in this case.
  ///   * or [Effect.smooth] - Length of this change is specified by [duration].
  /// * [duration] - the duration of the effect. The minimum is
  /// 30 milliseconds. Ignored for [Effect.sudden].
  ///
  /// **Example**:
  /// ```dart
  /// device.turnOn(effect: Effect.sudden());
  /// ```
  Future<CommandResponse> turnOn({
    int id,
    Effect effect = const Effect.smooth(),
    Duration duration = const Duration(milliseconds: 30),
  }) async {
    return commandSender.sendCommand(
      Command.setPower(
        id: id,
        power: 'on',
        effect: effect.value,
        duration: duration.inMilliseconds,
      ),
    );
  }

  /// This method is used to turn the device **OFF**.
  ///
  /// * [effect]
  ///   * [Effect.sudden] - parameter [duration] is ignored in this case.
  ///   * or [Effect.smooth] - Length of this change is specified by [duration].
  /// * [duration] - the duration of the effect. The minimum is
  /// 30 milliseconds. Ignored for [Effect.sudden].
  ///
  /// **Example**:
  /// ```dart
  /// device.turnOff();
  /// ```
  Future<CommandResponse> turnOff({
    int id,
    Effect effect = const Effect.sudden(),
    Duration duration = const Duration(milliseconds: 30),
  }) async {
    return commandSender.sendCommand(
      Command.setPower(
        id: id,
        power: 'off',
        effect: effect.value,
        duration: duration.inMilliseconds,
      ),
    );
  }

  /// This method is used to toggle the the light.
  ///
  /// * [lightType] - type of light to control (main or background or both),
  /// see [LightType].
  ///
  /// **Example**:
  /// ```dart
  /// device.toggle();
  /// ```
  Future<CommandResponse> toggle({int id, LightType lightType}) async {
    if (lightType == LightType.main) {
      return commandSender.sendCommand(Command.toggle(id: id));
    } else if (lightType == LightType.backgroud) {
      return commandSender.sendCommand(Command.bgToggle(id: id));
    } else {
      return commandSender.sendCommand(Command.devToggle(id: id));
    }
  }

  /// This method is used to save current state of the light to
  /// persistent memory.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  ///
  /// **Example**:
  /// ```dart
  /// device.setDefault();
  /// ```
  Future<CommandResponse> setDefault({int id, LightType lightType}) async {
    final cmd = lightType == LightType.main
        ? Command.setDefault(id: id)
        : Command.bgSetDefault(id: id);
    return commandSender.sendCommand(cmd);
  }

  /// This method is used to start a color flow.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [flow] - flow to start, see [Flow].
  ///
  /// **Example**:
  /// ```dart
  /// device.startFlow(
  ///   flow: Flow(
  ///     count: 4,
  ///     action: FlowAction.turnOff(),
  ///     transitions: [
  ///       FlowTransition.rgb(color: Colors.red),
  ///       FlowTransition.sleep(),
  ///       FlowTransition.rgb(color: Colors.green),
  ///     ],
  ///   )
  /// );
  /// ```
  /// or you can use preset, for example:
  /// ```dart
  /// device.startFlow(flow: Flow.rgb())
  /// ```
  Future<CommandResponse> startFlow({
    int id,
    LightType lightType = LightType.main,
    @required Flow flow,
  }) async {
    final cmd = lightType == LightType.main
        ? Command.startColorFlow(
            id: id,
            count: flow.count,
            action: flow.action.value,
            flowExpression: flow.expression,
          )
        : Command.bgStartColorFlow(
            id: id,
            count: flow.count,
            action: flow.action.value,
            flowExpression: flow.expression,
          );

    return commandSender.sendCommand(cmd);
  }

  /// This method is used to stop a running color flow.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  ///
  /// **Example**:
  /// ```dart
  /// device.stopFlow();
  /// ```
  Future<CommandResponse> stopFlow({
    int id,
    LightType lightType = LightType.main,
  }) async {
    final cmd = lightType == LightType.main
        ? Command.stopColorFlow(id: id)
        : Command.bgStopColorFlow(id: id);
    return commandSender.sendCommand(cmd);
  }

  /// This method is used to set the device (**main light**) directly to
  /// specified state. If the device is off, it will turn the device on and
  /// then apply this command.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [scene] - scene to set, see [Scene].
  ///
  /// **Example**:
  /// ```dart
  /// device.setScene();
  /// ```
  Future<CommandResponse> setScene({
    int id,
    LightType lightType = LightType.main,
    @required Scene scene,
  }) async {
    final cmd = lightType == LightType.main
        ? Command.setScene(
            id: id,
            cls: scene.sceneClass.value,
            val1: scene.val1,
            val2: scene.val2,
            val3: scene.val3,
          )
        : Command.bgSetScene(
            id: id,
            cls: scene.sceneClass.value,
            val1: scene.val1,
            val2: scene.val2,
            val3: scene.val3,
          );

    return commandSender.sendCommand(cmd);
  }

  /// This method is used to start a timer.
  ///
  /// NOTE: Currently supports only type 0 (turn off).
  ///
  /// **Method**: `cron_add`\
  /// **Command**: [Command.cronAdd]
  ///
  /// **Example**:
  /// ```dart
  /// device.cronAdd(timer: Duration(minutes: 10));
  /// ```
  Future<CommandResponse> cronAdd({int id, @required Duration timer}) async {
    return commandSender.sendCommand(
      Command.cronAdd(id: id, value: timer.inMinutes),
    );
  }

  /// This method is used to get the setting of current cron job of the
  /// specific type.
  ///
  /// NOTE: Currently supports only type 0 (turn off).
  ///
  /// **Method**: `cron_get`\
  /// **Command**: [Command.cronGet]
  ///
  /// **Example**:
  /// ```dart
  /// device.cronGet();
  /// ```
  Future<CommandResponse> cronGet({int id}) async {
    return commandSender.sendCommand(Command.cronGet(id: id));
  }

  /// This method is used to stop the specified cron job.
  ///
  /// NOTE: Currently supports only type 0 (turn off).
  ///
  /// **Method**: `cron_del`\
  /// **Command**: [Command.cronDelete]
  ///
  /// **Example**:
  /// ```dart
  /// device.cronDelete();
  /// ```
  Future<CommandResponse> cronDelete({int id}) async {
    return commandSender.sendCommand(Command.cronDelete(id: id));
  }

  /// This method is used to change brightness, color temperature or color of
  /// device main light without knowing the current value.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [action] - direction of adjustment.
  ///   * [AdjustAction.increase]
  ///   * [AdjustAction.decrease]
  ///   * [AdjustAction.circle]
  /// * [property] - property to adjust,
  ///   * [AdjustProperty.brightness]
  ///   * [AdjustProperty.colorTemperature]
  ///   * [AdjustProperty.color] - [action] can be only [AdjustAction.circle].
  ///
  /// **Example**:
  /// ```dart
  /// device.setAdjust(
  ///   action: AdjustAction.increase(),
  ///   property: AdjustProperty.brightness(),
  /// );
  /// ```
  Future<CommandResponse> setAdjust({
    int id,
    LightType lightType = LightType.main,
    @required AdjustAction action,
    @required AdjustProperty property,
  }) async {
    final cmd = lightType == LightType.main
        ? Command.setAdjust(
            id: id,
            action: action.value,
            property: property.value,
          )
        : Command.bgSetAdjust(
            id: id,
            action: action.value,
            property: property.value,
          );
    return commandSender.sendCommand(cmd);
  }

  /// This method is used to start or stop music mode on device.
  /// Under music mode, no property will be reported and no message quota is
  /// checked.
  ///
  /// * [action] - 0 to turn off music mode, 1 to turn on music mode.
  /// * [host] - the IP adress of the music server.
  /// * [port] - the TCP port music application is listening on.
  ///
  /// **Example**:
  /// ```dart
  /// device.setMusic(
  ///   action: 1,
  ///   host: '192.168.0.2',
  ///   port: 54321,
  /// );
  /// ```
  Future<CommandResponse> setMusic({
    int id,
    @required int action,
    @required String host,
    @required int port,
  }) async {
    return commandSender.sendCommand(Command.setMusic(
      id: id,
      action: action,
      host: host,
      port: port,
    ));
  }

  /// This method is used to set name for device. The name will be stored on
  /// the device and reported in discovering response.
  ///
  /// When using Yeelight official App, the device name is stored on cloud.
  /// This method instead store the name on persistent memory of the device,
  /// so the two names could be different.
  ///
  /// **Method**: `set_name`\
  /// **Command**: [Command.setName]
  ///
  /// **Example**:
  /// ```dart
  /// device.setName(name: 'My bulb');
  /// ```
  Future<CommandResponse> setName({int id, @required String name}) async {
    return commandSender.sendCommand(Command.setName(id: id, name: name));
  }

  /// This method is used to adjust the brightness by specified percentage
  /// within specified duration.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [percentage] - percentage to be adjusted. Range is from -100 to 100.
  /// * [duration] - the duration of the effect. The minimum is 30 milliseconds.
  ///
  /// **Example**:
  /// ```dart
  /// device.adjustBrightness(
  ///   percentage: -20,
  ///   duration: Duration(milliseconds: 500),
  /// );
  /// ```
  Future<CommandResponse> adjustBrightness({
    int id,
    LightType lightType = LightType.main,
    @required int percentage,
    @required Duration duration,
  }) async {
    final cmd = lightType == LightType.main
        ? Command.adjustBrightness(
            id: id,
            percentage: percentage,
            duration: duration.inMilliseconds,
          )
        : Command.bgAdjustBrightness(
            id: id,
            percentage: percentage,
            duration: duration.inMilliseconds,
          );
    return commandSender.sendCommand(cmd);
  }

  /// This method is used to adjust the color temperature by specified
  /// percentage within specified duration.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [percentage] - percentage to be adjusted. Range is from -100 to 100.
  /// * [duration] - the duration of the effect. The minimum is 30 milliseconds.
  ///
  /// **Example**:
  /// ```dart
  /// device.adjustColorTemperature(
  ///   percentage: 20,
  ///   duration: Duration(milliseconds: 500),
  /// );
  /// ```
  Future<CommandResponse> adjustColorTemperature({
    int id,
    LightType lightType = LightType.main,
    @required int percentage,
    @required Duration duration,
  }) async {
    final cmd = lightType == LightType.main
        ? Command.adjustColorTemperature(
            id: id,
            percentage: percentage,
            duration: duration.inMilliseconds,
          )
        : Command.bgAdjustColorTemperature(
            id: id,
            percentage: percentage,
            duration: duration.inMilliseconds,
          );

    return commandSender.sendCommand(cmd);
  }

  /// This method is used to adjust the color within specified duration.
  ///
  /// * [lightType] - type of light to control (main or background),
  /// see [LightType].
  /// * [percentage] - percentage to be adjusted. Range is from -100 to 100.
  /// * [duration] - the duration of the effect. The minimum is 30 milliseconds.
  ///
  /// **Example**:
  /// ```dart
  /// device.adjustColor(
  ///   percentage: 20,
  ///   duration: Duration(milliseconds: 500),
  /// );
  /// ```
  ///
  /// NOTE: The percentage parameter will be ignored and the color is
  /// internally defined and can’t specified.
  Future<CommandResponse> adjustColor({
    int id,
    LightType lightType = LightType.main,
    @required int percentage,
    @required Duration duration,
  }) async {
    final cmd = lightType == LightType.main
        ? Command.adjustColor(
            id: id,
            percentage: percentage,
            duration: duration.inMilliseconds,
          )
        : Command.bgAdjustColor(
            id: id,
            percentage: percentage,
            duration: duration.inMilliseconds,
          );
    return commandSender.sendCommand(cmd);
  }

  /// Allows to send any [Command].
  Future<CommandResponse> sendCommand(Command command) async {
    return commandSender.sendCommand(command);
  }

  /// When there is a device state change, the device will send a notification
  /// message to all connected clients. This is to make sure all clients will
  /// get the latest device state in time without having to poll the status
  /// from time to time.
  ///
  /// Example:
  /// ```dart
  /// device.onNotificationReceived((message) {
  ///   // do something with message
  /// })
  /// ```
  void onNotificationReceived(void Function(NotificationMessage) onData) {
    commandSender.connectionStream.listen((event) {
      try {
        final parsed = json.decode(utf8.decode(event)) as Map<String, dynamic>;
        final msg = NotificationMessage.fromJson(parsed);

        if (msg.params != null && msg.method != null) {
          onData(msg);
        }
      } catch (_) {
        // when parsing fails, do nothing
      }
    });
  }

  /// Disconnects from device.
  ///
  /// You should close connection when you are finished using it.
  void disconnect() {
    commandSender.close();
  }

  @override
  int get hashCode => address.hashCode ^ port.hashCode ^ commandSender.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Device &&
            runtimeType == other.runtimeType &&
            address == other.address &&
            port == other.port &&
            commandSender == other.commandSender;
  }

  @override
  String toString() => 'Device(address: $address, port: $port)';
}
