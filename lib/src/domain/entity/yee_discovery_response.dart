import 'dart:io';

/// Response send by devices after discovery message.
class YeeDiscoveryResponse {
  /// Status refresh interval. Smart LED will send another advertisement message
  /// after that amount of seconds.
  ///
  /// Header: `Cache-Control: max-age=<value>`
  final int refreshInterval;

  /// Doesn't contain any important information,
  /// it's there just to confirm with SSDP.
  ///
  /// Header: `Date: `
  final String date;

  /// Doesn't contain any important information,
  /// it's there just to confirm with SSDP.
  ///
  /// Header: `Ext: `
  final String ext;

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

  YeeDiscoveryResponse({
    this.refreshInterval,
    this.date,
    this.ext,
    this.address,
    this.port,
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

  YeeDiscoveryResponse.fromMap(Map<String, String> response)
      : refreshInterval = int.tryParse(response["refresh_interval"]),
        date = response["date"],
        ext = response["ext"],
        address = InternetAddress(response["address"]),
        port = int.tryParse(response["port"]),
        id = int.tryParse(response["id"]),
        model = response["model"],
        firmwareVersion = int.tryParse(response["port"]),
        supportedControls = response["support"].split(r"\s"),
        powered = response["power"] == "on",
        brightness = int.tryParse(response["bright"]),
        colorMode = int.tryParse(response["color_mode"]),
        colorTemperature = int.tryParse(response["ct"]),
        rgb = int.tryParse(response["rgb"]),
        hue = int.tryParse(response["hue"]),
        sat = int.tryParse(response["sat"]),
        name = response["name"],
        rawResponse = response["raw"];

  @override
  int get hashCode => rawResponse.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is YeeDiscoveryResponse && rawResponse == other.rawResponse;
  }
  
  @override
  String toString() => "RawYeelightResponse(refreshInterval: $refreshInterval, "
      "ipAddress: $address, port: $port, id: $id, model: $model, "
      "firmwareVersion: $firmwareVersion, "
      "supportedControls: <$supportedControls>, powered: $powered, "
      "brightness: $brightness, colorMode: $colorMode, "
      "colorTemperature: $colorTemperature, rgb: $rgb, hue: $hue, sat: $sat, "
      "name: $name)";
}
