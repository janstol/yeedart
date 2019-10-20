import 'package:yeedart/src/util/enum.dart';

/// Class of [Scene].
class SceneClass extends Enum<String> {
  /// Turn on the device to specified brightness and start a timer to turn off
  /// the light after specified number of minutes.
  const SceneClass.autoDelayOff() : this._("auto_delay_off");

  /// Change the device to specified color and brightness
  const SceneClass.color() : this._("color");

  /// Start a color flow in specified style.
  const SceneClass.colorFlow() : this._("cf");

  /// Change the device to specified ct and brightness.
  const SceneClass.colorTemperature() : this._("ct");

  /// Change the device to specified color and brightness.
  const SceneClass.hsv() : this._("hsv");

  const SceneClass._(String value) : super(value);
}
