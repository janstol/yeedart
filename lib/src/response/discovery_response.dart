import 'dart:io';

import 'package:meta/meta.dart';

/// Response send by devices after discovery message.
class DiscoveryResponse {
  /// Status refresh interval. Smart LED will send another advertisement message
  /// after that amount of seconds.
  ///
  /// Header: `Cache-Control: max-age=<value>`
  final int refreshInterval;

  /// IP address of smart LED.
  ///
  /// Header `Location: yeelight://<address>:<port>`
  final InternetAddress address;

  /// TCP listen port.
  ///
  /// Header `Location: yeelight://<address>:<port>`
  final int port;

  /// ID of Yeelight WiFi LED device.
  ///
  /// Header: `id: <value>`
  final int id;

  /// The product model of Yeelight smart device.
  ///
  /// * mono - device that only supports brightness adjustment
  /// * color - device that supports both color and color temperature adjustment
  /// * stripe - Yeelight smart LED stripe
  /// * ceiling - Yeelight Ceiling Light
  /// * bslamp - ?
  ///
  /// More values may be added in the future.
  ///
  /// Header: `model: <value>`
  final String model;

  /// Firmware version of LED device.
  ///
  /// Header: `fw_ver: <value>`
  final int firmwareVersion;

  /// All the supported control methods.
  ///
  /// Header: `support: <values>`
  final List<String> supportedControls;

  /// Current status of the device.
  ///
  /// * true = device is currently turned ON
  /// * false = device is currently turned OFF
  ///
  /// Header: `power: <on|off>`
  final bool powered;

  /// Current brightness. It's the percentage of maximum brightness.
  ///
  /// Range of this values is 1 ~ 100.
  ///
  /// Header: `bright: <value>`
  final int brightness;

  /// Current light mode.
  ///
  /// * 1 - color mode
  /// * 2 - color temperature mode
  /// * 3 - HSV mode
  ///
  /// Header: `color_mode: <value>`
  final int colorMode;

  /// Current color temperature value. The range of this value depends on
  /// product model, refer to Yeelight product description.
  ///
  /// This field is valid only if [colorMode] is 2.
  ///
  /// Header: `ct: <value>`
  final int colorTemperature;

  /// Current RGB value.
  ///
  /// This field is valid only if [colorMode] is 1.
  ///
  /// Header: `rgb: <value>`
  final int rgb;

  /// Current HUE value. The range of this value is from 0 to 359.
  ///
  /// This field is valid only if [colorMode] is 3.
  /// Should be used in combination with [sat].
  ///
  /// Header: `hue: <value>`
  final int hue;

  /// Current saturation value. The range of this value is from 0 to 100.
  ///
  /// This field is valid only if [colorMode] is 3.
  /// Should be used in combination with [hue].
  ///
  /// Header: `sat: <value>`
  final int sat;

  /// Name of the device.
  ///
  /// The maximum length is 64 bytes.
  ///
  /// NOTE:
  /// When using Yeelight official App, the device name is stored on cloud.
  /// The [name] is stored on persistent memory of the device, so the two names
  /// can be different.
  ///
  /// Header: `name: <value>`
  final String name;

  /// Raw response.
  ///
  /// ```
  /// HTTP/1.1 200 OK
  /// Cache-Control: max-age=3600
  /// Date:
  /// Ext:
  /// .
  /// .
  /// ....
  /// ```
  final String rawResponse;

  DiscoveryResponse({
    this.refreshInterval,
    @required this.address,
    @required this.port,
    this.id,
    this.model,
    this.firmwareVersion,
    this.supportedControls,
    this.powered,
    this.brightness,
    this.colorMode,
    this.colorTemperature,
    this.rgb,
    this.hue,
    this.sat,
    this.name,
    this.rawResponse,
  });

  factory DiscoveryResponse.fromRawResponse(String rawResponse) {
    final regExp = RegExp(
      r'HTTP/1.1 200 OK\r\n'
      r'Cache-Control: max-age=(?<refresh_interval>\d+)\r\n'
      r'Date:(?<date>.*)\r\n'
      r'Ext:(?<ext>.*)\r\n'
      r'Location: yeelight://(?<address>(?=.*[^\.]$)((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.?){4})\:(?<port>\d+)\r\n'
      r'Server: (?<server>.*)\r\n'
      r'id: (?<id>.*)\r\n'
      r'model: (?<model>.*)\r\n'
      r'fw_ver: (?<fw_ver>.*)\r\n'
      r'support: (?<support>.*)\r\n'
      r'power: (?<power>.*)\r\n'
      r'bright: (?<bright>.*)\r\n'
      r'color_mode: (?<color_mode>.*)\r\n'
      r'ct: (?<ct>\d+)\r\n'
      r'rgb: (?<rgb>\d+)\r\n'
      r'hue: (?<hue>\d+)\r\n'
      r'sat: (?<sat>[0-9]|[1-8][0-9]|9[0-9]|100)\r\n'
      r'name: (?<name>.*)\r\n',
      dotAll: true,
      caseSensitive: false,
      multiLine: true,
    );

    final match = regExp.firstMatch(rawResponse);

    return DiscoveryResponse(
      refreshInterval: int.tryParse(match.namedGroup('refresh_interval')),
      address: InternetAddress(match.namedGroup('address')),
      port: int.tryParse(match.namedGroup('port')),
      id: int.tryParse(match.namedGroup('id')),
      model: match.namedGroup('model'),
      firmwareVersion: int.tryParse(match.namedGroup('port')),
      supportedControls: match.namedGroup('support')?.split(r'\s'),
      powered: match.namedGroup('power') == 'on',
      brightness: int.tryParse(match.namedGroup('bright')),
      colorMode: int.tryParse(match.namedGroup('color_mode')),
      colorTemperature: int.tryParse(match.namedGroup('ct')),
      rgb: int.tryParse(match.namedGroup('rgb')),
      hue: int.tryParse(match.namedGroup('hue')),
      sat: int.tryParse(match.namedGroup('sat')),
      name: match.namedGroup('name'),
      rawResponse: rawResponse,
    );
  }

  @override
  int get hashCode => rawResponse.hashCode ^ runtimeType.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DiscoveryResponse &&
            runtimeType == other.runtimeType &&
            rawResponse == other.rawResponse;
  }

  @override
  String toString() => 'DiscoveryResponse(refreshInterval: $refreshInterval, '
      'ipAddress: $address, port: $port, id: $id, model: $model, '
      'firmwareVersion: $firmwareVersion, '
      'supportedControls: <$supportedControls>, powered: $powered, '
      'brightness: $brightness, colorMode: $colorMode, '
      'colorTemperature: $colorTemperature, rgb: $rgb, hue: $hue, sat: $sat, '
      'name: $name)';
}
