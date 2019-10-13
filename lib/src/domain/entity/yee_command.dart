import 'dart:convert';

import 'package:meta/meta.dart';

/// Commands are sent by [CommandSender] to control Yeelight device.
///
/// [id] - integer filled by message sender. It will be echoed back in response
/// message. This is to help request sender to correlate request and response.
/// If no [id] is provided, [hashCode] is used as id.
///
/// [method] - specifies which control method should be invoked. The value
/// should be selected from [YeelightDevice.supportedMethods], otherwise
/// the message may be rejected by device. See [YeeCommandMethods].
///
/// [parameters] - list of parameters, method specific.
///
/// NOTE: "bg" methods are used to control background light. These commands are
/// only supported on lights that are equipped with a background light.
class YeeCommand {
  int id;
  final String method;
  final List<dynamic> parameters;

  YeeCommand(this.id, this.method, this.parameters);

  /// Command to retrieve current property of the device.
  ///
  /// * [parameters] - a list of property names and the response contains
  /// a list of corresponding property values. If the requested property name is
  /// not recognized by device, then an empty string value will be returned.
  YeeCommand.getProp({this.id, @required this.parameters})
      : method = YeeCommandMethods.getProp;

  /// Command to set color temperature of the device (main light).
  ///
  /// * [colorTemperature] - the target color temperature.
  /// * [effect] - supports two values - "sudden" and "smooth".
  /// * [duration] - total time of the gradual changing in milliseconds. Minimal
  /// supported duration is 30 milliseconds.
  ///
  /// This command is accepted only if the device is in "ON" state.
  YeeCommand.setColorTemperature({
    this.id,
    @required int colorTemperature,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.setCtAbx,
        parameters = <dynamic>[colorTemperature, effect, duration];

  /// Command to set color of the device (main light).
  ///
  /// * [rgb] - the target color. It should be represented as integer in range
  /// from 0 to 16777215 (hex:0xFFFFFF)
  /// * [effect] - same as in [YeeCommand.setColorTemperature].
  /// * [duration] - same as in [YeeCommand.setColorTemperature].
  ///
  /// This command is accepted only if the device is in "ON" state.
  YeeCommand.setRGB({
    this.id,
    @required int rgb,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.setRGB,
        parameters = <dynamic>[rgb, effect, duration];

  /// Command to set color of the device (main light).
  ///
  /// * [hue] - the target hue value. It should be in range from 0 to 359.
  /// * [saturation] - the target saturation value.
  /// It should be in range from 0 to 100.
  /// * [effect] - same as in [YeeCommand.setColorTemperature].
  /// * [duration] - same as in [YeeCommand.setColorTemperature].
  ///
  /// This command is accepted only if the device is in "ON" state.
  YeeCommand.setHSV({
    this.id,
    @required int hue,
    @required int saturation,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.setHSV,
        parameters = <dynamic>[hue, saturation, effect, duration];

  /// Command to set brightness of the device (main light).
  ///
  /// * [brightness] - the target brightness. Ranges from 1 to 100, where
  /// 1 means minimum brightness, 100 means maximum brightness.
  /// * [effect] - same as in [YeeCommand.setColorTemperature].
  /// * [duration] - same as in [YeeCommand.setColorTemperature].
  ///
  /// This command is accepted only if the device is in "ON" state.
  YeeCommand.setBrightness({
    this.id,
    @required int brightness,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.setBright,
        parameters = <dynamic>[brightness, effect, duration];

  /// Command to switch on or off the device (main light).
  ///
  /// * [power] - only "on" or "off" values.
  /// * [effect] - same as in [YeeCommand.setColorTemperature].
  /// * [duration] - same as in [YeeCommand.setColorTemperature].
  /// * [mode] (optional)
  ///   * 0 - normal turn on operation (default value)
  ///   * 1 - turn on and switch to color temperature mode
  ///   * 2 - turn on and switch to RGB mode
  ///   * 3 - turn on and switch to HSV mode
  ///   * 4 - turn on and switch to color flow mode
  ///   * 5 - turn on and switch to Night light mode (ceiling light only).
  ///
  YeeCommand.setPower({
    this.id,
    @required String power,
    @required String effect,
    @required int duration,
    int mode,
  })  : method = YeeCommandMethods.setPower,
        parameters = <dynamic>[power, effect, duration, if (mode != null) mode];

  /// Command to toggle the device (main light).
  ///
  /// This method is defined because sometimes user may just want to flip
  /// the state without knowing the current state.
  YeeCommand.toggle({this.id})
      : method = YeeCommandMethods.toggle,
        parameters = const <void>[];

  /// Command to save current state of main light to persistent memory.
  ///
  /// This command is accepted only if the device is in "ON" state.
  YeeCommand.setDefault({this.id})
      : method = YeeCommandMethods.setDefault,
        parameters = const <void>[];

  /// Command to start a color flow (main light).
  ///
  /// * [count] - the total number of visible state changes before color flow
  /// stops. 0 means infinite loop.
  /// * [action] - the action taken after the flow is stopped:
  ///   * 0 device recovers to the state before the color flow started
  ///   * 1 devices stays at the same state whe the flow stopped
  ///   * 2 turn off the device after the flow is stopped
  /// [flowExpression] - the expression of the state changing series.
  /// Each state is defined as a 4-tuple `[duration, mode, value, brightness]`
  ///   * duration - in milliseconds, minimum 50
  ///   * mode - 1: color, 2: color temperature, 7: sleep
  ///   * value - RGB when mode is 1, color temperature when mode is 2,
  ///   ignored when mode is 7.
  ///   * brightness - brightness value, -1 or 1 ~ 100. Ignored when mode is 7.
  ///   When this value is -1, brightness in this tuple is ignored.
  ///
  /// This command is accepted only if the device is in "ON" state.
  ///
  /// TODO
  YeeCommand.startColorFlow({
    this.id,
    @required int count,
    @required int action,
    @required String flowExpression,
  })  : method = YeeCommandMethods.startCF,
        parameters = <dynamic>[count, action, flowExpression];

  /// Command to stop a running color flow.
  YeeCommand.stopColorFlow({this.id})
      : method = YeeCommandMethods.stopCF,
        parameters = <void>[];

  /// Command to set the device directly to specified state. If the device
  /// is off, it will turn the device on and then apply this command
  /// (main light).
  ///
  /// * [cls] (class)
  ///   * `"color"` - change the device to specified color and brightness
  ///   * `"hsv"` - change the device to specified color and brightness.
  ///   * `"ct"` - change the device to specified ct and brightness.
  ///   * `"cf"` - start a color flow in specified style.
  ///   * `"auto_delay_off"` - turn on the device to specified brightness and
  ///   start a timer to turn off the light after specified number of minutes.
  /// * [val1], [val2], [val3] - class specific values.
  ///
  /// TODO
  YeeCommand.setScene({
    this.id,
    @required String cls,
    @required int val1,
    @required int val2,
    String val3,
  })  : method = YeeCommandMethods.setScene,
        parameters = <dynamic>[cls, val1, val2, if (val3 != null) val3];

  /// Command to start a timer job on the device.
  ///
  /// * [type] - currently can by only 0 (means power off)
  /// * [value] is the length of the timer in minutes.
  ///
  /// This command is accepted only if the device is in "ON" state.
  YeeCommand.cronAdd({this.id, int type = 0, @required int value})
      : method = YeeCommandMethods.cronAdd,
        parameters = <int>[type, value];

  /// Command to retrieve the settings for the current cron job of the specified
  /// type.
  ///
  /// * [type] - type of the cron job (currently only 0,
  /// see [YeeCommand.cronAdd]).
  YeeCommand.cronGet({this.id, int type = 0})
      : method = YeeCommandMethods.cronGet,
        parameters = <dynamic>[type];

  /// Command to stop the specific cron job.
  ///
  /// * [type] - type of the cron job (currently only 0,
  /// see [YeeCommand.cronAdd]).
  YeeCommand.cronDelete({this.id, int type = 0})
      : method = YeeCommandMethods.cronDel,
        parameters = <dynamic>[type];

  /// Command to change brightness, color temperature or color without knowing
  /// current value (main light).
  ///
  /// * [action]
  ///   * `"increase"` - increase the specified property
  ///   * `"decrease"` - decrease the specified property
  ///   * `"circle"` - increase the specified property, after it reaches the max
  ///   value go back to minimum value.
  ///
  /// * [property]
  ///   * `"bright"` - adjust brightness
  ///   * `"ct"` - adjust color temperature
  ///   * `"color"` - adjust color
  ///
  /// When [property] is `"color"`, the [action] can be only `"circle"`.
  YeeCommand.setAdjust({
    this.id,
    @required String action,
    @required String property,
  })  : method = YeeCommandMethods.setAdjust,
        parameters = <String>[action, property];

  /// Command to start or stop music mode (main light).
  ///
  /// When music mode is enabled, no property will be reported back and no
  /// message quota is checked.
  ///
  /// * [action] - 0 to turn off music mode, 1 to turn on music mode.
  /// * [host] - the IP adress of the music server.
  /// * [port] - the TCP port music application is listening on.
  YeeCommand.setMusic({
    this.id,
    @required int action,
    @required String host,
    @required int port,
  })  : method = YeeCommandMethods.setMusic,
        parameters = <dynamic>[action, host, port];

  /// Command to set name for the device. The name will be stored on the device
  /// and reported in discovery response.
  ///
  /// When using Yeelight official App, the device name is stored on cloud.
  /// This method instead store the name on persistent memory of the device,
  /// so the two names could be different.
  YeeCommand.setName({this.id, @required String name})
      : method = YeeCommandMethods.setName,
        parameters = <String>[name];

  /// Command to set color of the background light.
  ///
  /// see [YeeCommand.setRGB]
  YeeCommand.bgSetRGB({
    this.id,
    @required int rgb,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.bgSetRGB,
        parameters = <dynamic>[rgb, effect, duration];

  /// Command to set color of the background light.
  ///
  /// see [YeeCommand.setHSV]
  YeeCommand.bgSetHSV({
    this.id,
    @required int hue,
    @required int saturation,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.bgSetHSV,
        parameters = <dynamic>[hue, saturation, effect, duration];

  /// Command to set color temperature of the background light.
  ///
  /// see [YeeCommand.setColorTemperature]
  YeeCommand.bgSetColorTemperature({
    this.id,
    @required int colorTemperature,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.bgSetCtAbx,
        parameters = <dynamic>[colorTemperature, effect, duration];

  /// Command to start a color flow (background light).
  ///
  /// see [YeeCommand.startColorFlow]
  YeeCommand.bgStartColorFlow({
    this.id,
    @required int count,
    @required int action,
    @required String flowExpression,
  })  : method = YeeCommandMethods.bgStartCF,
        parameters = <dynamic>[count, action, flowExpression];

  /// Command to stop a running color flow (background light).
  YeeCommand.bgStopColorFlow({this.id})
      : method = YeeCommandMethods.bgStopCF,
        parameters = <void>[];

  /// Command to set the background light directly to specified state.
  ///
  /// see [YeeCommand.setScene]
  YeeCommand.bgSetScene({
    this.id,
    @required String cls,
    @required int val1,
    @required int val2,
    String val3,
  })  : method = YeeCommandMethods.bgSetScene,
        parameters = <dynamic>[cls, val1, val2, if (val3 != null) val3];

  /// Command to save current state of background light to persistent memory.
  ///
  /// This command is accepted only if the device is in "ON" state.
  YeeCommand.bgSetDefault({this.id})
      : method = YeeCommandMethods.bgSetDefault,
        parameters = const <void>[];

  /// Command to switch on or off the background light.
  ///
  /// see [YeeCommand.setPower]
  YeeCommand.bgSetPower({
    this.id,
    @required String power,
    @required String effect,
    @required int duration,
    int mode,
  })  : method = YeeCommandMethods.bgSetPower,
        parameters = <dynamic>[power, effect, duration, if (mode != null) mode];

  /// Command to set brightness of the background light.
  ///
  /// see [YeeCommand.setBrightness]
  YeeCommand.bgSetBrightness({
    this.id,
    @required int brightness,
    @required String effect,
    @required int duration,
  })  : method = YeeCommandMethods.bgSetBright,
        parameters = <dynamic>[brightness, effect, duration];

  /// Command to change brightness, color temperature or color without knowing
  /// current value (background light).
  ///
  /// see [YeeCommand.setAdjust]
  YeeCommand.bgSetAdjust({
    this.id,
    @required String action,
    @required String property,
  })  : method = YeeCommandMethods.bgSetAdjust,
        parameters = <String>[action, property];

  /// Command to toggle the background light.
  ///
  /// This method is defined because sometimes user may just want to flip
  /// the state without knowing the current state.
  YeeCommand.bgToggle({this.id})
      : method = YeeCommandMethods.bgToggle,
        parameters = const <void>[];

  /// Command to toggle the main and background light at the same time.
  ///
  /// When there is main light and background light, [YeeCommand.toggle] is used
  /// to toggle main light, [YeeCommand.bgToggle] is used to toggle background
  /// light while [YeeCommand.devToggle] is used to toggle both light
  /// at the same time.
  YeeCommand.devToggle({this.id})
      : method = YeeCommandMethods.devToggle,
        parameters = <void>[];

  /// Command to adjust the brightness by specified percentage within specified
  /// duration.
  ///
  /// * [percentage] - percentage to be adjusted. Range is from -100 to 100.
  /// * [duration] - see [YeeCommand.setColorTemperature]
  ///
  YeeCommand.adjustBrightness({
    this.id,
    @required int percentage,
    @required int duration,
  })  : method = YeeCommandMethods.adjustBright,
        parameters = <int>[percentage, duration];

  /// Command to adjust the color temperature by specified percentage within
  /// specified duration.
  ///
  /// * [percentage] - percentage to be adjusted. Range is from -100 to 100.
  /// * [duration] - see [YeeCommand.setColorTemperature]
  ///
  YeeCommand.adjustColorTemperature({
    this.id,
    @required int percentage,
    @required int duration,
  })  : method = YeeCommandMethods.adjustCT,
        parameters = <int>[percentage, duration];

  /// Command to adjust the color  within specified duration.
  ///
  /// * [percentage] - percentage to be adjusted. Range is from -100 to 100.
  /// * [duration] - see [YeeCommand.setColorTemperature]
  ///
  /// NOTE: The percentage parameter will be ignored and the color is
  /// internally defined and can’t specified.
  YeeCommand.adjustColor({
    this.id,
    @required int percentage,
    @required int duration,
  })  : method = YeeCommandMethods.adjustColor,
        parameters = <int>[percentage, duration];

  /// Command to adjust the brightness by specified percentage within specified
  /// duration (background light).
  ///
  /// see [YeeCommand.adjustBrightness]
  YeeCommand.bgAdjustBrightness({
    this.id,
    @required int percentage,
    @required int duration,
  })  : method = YeeCommandMethods.bgAdjustBright,
        parameters = <int>[percentage, duration];

  /// Command to adjust the color temperature by specified percentage within
  /// specified duration (background light).
  ///
  /// see [YeeCommand.adjustColorTemperature]
  YeeCommand.bgAdjustColorTemperature({
    this.id,
    @required int percentage,
    @required int duration,
  })  : method = YeeCommandMethods.bgAdjustCT,
        parameters = <int>[percentage, duration];

  /// Command to adjust the color  within specified duration (background light).
  ///
  /// see [YeeCommand.adjustColor]
  YeeCommand.bgAdjustColor({
    this.id,
    @required int percentage,
    @required int duration,
  })  : method = YeeCommandMethods.bgAdjustColor,
        parameters = <int>[percentage, duration];

  /// Command message. Used when sending command.
  String get message {
    final msg = json.encode(<String, dynamic>{
      "id": id ??= hashCode,
      "method": method,
      "params": parameters,
    });
    return "$msg\r\n";
  }

  @override
  int get hashCode => id.hashCode ^ method.hashCode ^ parameters.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is YeeCommand &&
            id == other.id &&
            method == other.method &&
            parameters.toString() == other.parameters.toString();
  }

  @override
  String toString() => "Command: $message";
}

/// All methods that can be used to control Yeelight devices.
///
/// Note that some devices does not support all methods.
abstract class YeeCommandMethods {
  static const getProp = "get_prop";
  static const setCtAbx = "set_ct_abx";
  static const setRGB = "set_rgb";
  static const setHSV = "set_hsv";
  static const setBright = "set_bright";
  static const setPower = "set_power";
  static const toggle = "toggle";
  static const setDefault = "set_default";
  static const startCF = "start_cf";
  static const stopCF = "stop_cf";
  static const setScene = "set_scene";
  static const cronAdd = "cron_add";
  static const cronGet = "cron_get";
  static const cronDel = "cron_del";
  static const setAdjust = "set_adjust";
  static const setMusic = "set_music";
  static const setName = "set_name";
  static const bgSetRGB = "bg_set_rgb";
  static const bgSetHSV = "bg_set_hsv";
  static const bgSetCtAbx = "bg_set_ct_abx";
  static const bgStartCF = "bg_start_cf";
  static const bgStopCF = "bg_stop_cf";
  static const bgSetScene = "bg_set_scene";
  static const bgSetDefault = "bg_set_default";
  static const bgSetPower = "bg_set_power";
  static const bgSetBright = "bg_set_bright";
  static const bgSetAdjust = "bg_set_adjust";
  static const bgToggle = "bg_toggle";
  static const devToggle = "dev_toggle";
  static const adjustBright = "adjust_bright";
  static const adjustCF = "adjust_cf";
  static const adjustCT = "adjust_ct";
  static const adjustColor = "adjust_color";
  static const bgAdjustBright = "bg_adjust_bright";
  static const bgAdjustCT = "bg_adjust_ct";
  static const bgAdjustColor = "bg_adjust_color";
}
