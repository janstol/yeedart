import 'package:meta/meta.dart';

class YeeDeviceColorMode {
  /// * 1 - color mode
  /// * 2 - color temperature mode
  /// * 3 - HSV mode
  final int id;

  /// Current color temperature value. The range of this value depends on
  /// product model, refer to Yeelight product description.
  ///
  /// This field is valid only if [colorMode] is 2.
  final int colorTemperature;

  /// Current RGB value.
  ///
  /// This field is valid only if [colorMode] is 1.
  final int rgb;

  /// Current HUE value. The range of this value is from 0 to 359.
  ///
  /// This field is valid only if [colorMode] is 3.
  /// Should be used in combination with [saturation].
  final int hue;

  /// Current saturation value. The range of this value is from 0 to 100.
  ///
  /// This field is valid only if [colorMode] is 3.
  /// Should be used in combination with [hue].
  final int saturation;

  factory YeeDeviceColorMode({
    int id,
    int rgb,
    int colorTemperature,
    int hue,
    int saturation,
  }) {
    if (id == 1) {
      return ColorMode(color: rgb);
    } else if (id == 2) {
      return ColorTemperatureColorMode(colorTemperature: colorTemperature);
    } else {
      return HSVColorMode(hue: hue, saturation: saturation);
    }
  }

  YeeDeviceColorMode._({
    @required this.id,
    this.rgb,
    this.colorTemperature,
    this.hue,
    this.saturation,
  });

  @override
  String toString() => "YeelightDeviceColorMode(id: $id, rgb: $rgb, "
      "colorTemperature: $colorTemperature, "
      "hue: $hue, saturation: $saturation)";
}

/// Only color mode.
class ColorMode extends YeeDeviceColorMode {
  ColorMode({@required int color}) : super._(id: 1, rgb: color);
}

/// Color temperature color mode.
class ColorTemperatureColorMode extends YeeDeviceColorMode {
  ColorTemperatureColorMode({@required int colorTemperature})
      : super._(id: 2, colorTemperature: colorTemperature);
}


/// HSV color mode.
class HSVColorMode extends YeeDeviceColorMode {
  HSVColorMode({@required int hue, @required int saturation})
      : super._(id: 3, hue: hue, saturation: saturation);
}
