import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yeedart/src/data/tcp_command_sender.dart';
import 'package:yeedart/src/domain/entity/yee_color_mode.dart';
import 'package:yeedart/src/domain/entity/yee_command.dart';
import 'package:yeedart/src/domain/entity/yee_command_response.dart';
import 'package:yeedart/src/domain/command_sender.dart';
import 'package:yeedart/src/domain/entity/yee_discovery_response.dart';

/// Represents Yeelight device (bulb, light, strip,...).
class YeeDevice {
  /// ID of Yeelight WiFi LED device.
  final int id;

  /// Name of the device.
  ///
  /// The maximum length is 64 bytes.
  ///
  /// NOTE:
  /// When using Yeelight official App, the device name is stored on cloud.
  /// The [name] is stored on persistent memory of the device, so the two names
  /// can be different.
  final String name;

  /// IP address of the device.
  final InternetAddress address;

  /// Port of the device.
  final int port;

  /// The product model of Yeelight smart device.
  ///
  /// * mono - device that only supports brightness adjustment
  /// * color - device that supports both color and color temperature adjustment
  /// * stripe - Yeelight smart LED stripe
  /// * ceiling - Yeelight Ceiling Light
  /// * bslamp - bedside lamp???
  ///
  /// More values may be added in the future.
  final String model;

  /// Firmware version of the device.
  final int firmwareVersion;

  /// All supported control methods.
  final List<String> supportedMethods;

  /// Current status of the device.
  ///
  /// * true = device is currently turned ON
  /// * false = device is currently turned OFF
  final bool powered;

  /// Current light mode.
  final YeeDeviceColorMode colorMode;

  /// Current brightness. It's the percentage of maximum brightness.
  ///
  /// Range of this values is 1 ~ 100.
  final int brightness;

  YeeCommandSender commandSender;

  YeeDevice({
    this.id,
    this.name,
    @required this.address,
    @required this.port,
    this.model,
    this.firmwareVersion,
    this.supportedMethods,
    this.powered,
    this.colorMode,
    this.brightness,
    this.commandSender,
  }) {
    commandSender ??= TCPCommandSender(address: address, port: port);

    //final props = getProps(parameters: ["id", "name", "model",]);
  }

  YeeDevice.fromResponse(YeeDiscoveryResponse response)
      : this(
          id: response.id,
          name: response.name,
          address: response.address,
          port: response.port,
          model: response.model,
          firmwareVersion: response.firmwareVersion,
          supportedMethods: response.supportedControls,
          powered: response.powered,
          colorMode: YeeDeviceColorMode(
            id: response.colorMode,
            rgb: response.rgb,
            colorTemperature: response.colorTemperature,
            hue: response.hue,
            saturation: response.sat,
          ),
          brightness: response.brightness,
        );

  /// Returns true if device supports [method], otherwise returns false.
  bool supportsMethod(String method) => supportedMethods.contains(method);

  /// This method is used to retrieve current property of smart LED.
  ///
  /// **Method**: `get_prop`\
  /// **Command**: [YeeCommand.getProp].
  ///
  /// **Example**:
  /// ```dart
  /// device.getProps(parameters: ["power", "not_exists", "bright"])
  /// ```
  Future<YeeCommandResponse> getProps({
    int id,
    @required List<String> parameters,
  }) async {
    return commandSender.sendCommand(
      YeeCommand.getProp(id: id, parameters: parameters),
    );
  }

  /// This method is used to set the color temperature of device.
  ///
  /// **Method**: `set_ct_abx`\
  /// **Command**: [YeeCommand.setColorTemperature].
  ///
  /// **Example**:
  /// ```dart
  /// device.setColorTemperature(
  ///   colorTemperature:3500,
  ///   effect: "smooth",
  ///   duration: 500,
  /// )
  /// ```
  Future<YeeCommandResponse> setColorTemperature({
    int id,
    int colorTemperature,
    String effect,
    int duration,
  }) async {
    return commandSender.sendCommand(YeeCommand.setColorTemperature(
      id: id,
      colorTemperature: colorTemperature,
      effect: effect,
      duration: duration,
    ));
  }

  /// This method is used to set the color of device.
  ///
  /// **Method**: `set_rgb`\
  /// **Command**: [YeeCommand.setRGB].
  ///
  /// **Example**:
  /// ```dart
  /// device.setRGB(
  ///   rgb: 255,
  ///   effect: "smooth",
  ///   duration: 500,
  /// )
  /// ```
  Future<YeeCommandResponse> setRGB({
    int id,
    int rgb,
    String effect,
    int duration,
  }) async {
    return commandSender.sendCommand(
      YeeCommand.setRGB(id: id, rgb: rgb, effect: effect, duration: duration),
    );
  }

  /// This method is used to set the color of device.
  ///
  /// **Method**: `set_hsv`\
  /// **Command**: [YeeCommand.setHSV].
  ///
  /// **Example**:
  /// ```dart
  /// device.setHSV(
  ///   hue: 255,
  ///   saturation: 45,
  ///   effect: "smooth",
  ///   duration: 500,
  /// )
  /// ```
  Future<YeeCommandResponse> setHSV({
    int id,
    int hue,
    int saturation,
    String effect,
    int duration,
  }) async {
    return commandSender.sendCommand(YeeCommand.setHSV(
      id: id,
      hue: hue,
      saturation: saturation,
      effect: effect,
      duration: duration,
    ));
  }



  /// Allows to send any [YeeCommand].
  Future<YeeCommandResponse> sendCommand(YeeCommand command) async {
    return commandSender.sendCommand(command);
  }

  /// Disconnects from device.
  void disconnect() {
    commandSender.close();
  }

  @override
  String toString() => "YeelightDevice(id: $id, name: $name, address: "
      "$address, port: $port, powered: $powered, model: $model, "
      "firmwareVersion: $firmwareVersion, "
      "supportedMethods: $supportedMethods, brightness: $brightness, "
      "colorMode: $colorMode)";
}
