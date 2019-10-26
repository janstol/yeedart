import 'package:meta/meta.dart';
import 'package:yeedart/src/command/color.dart';
import 'package:yeedart/src/flow/flow.dart';
import 'package:yeedart/src/scene/scene_class.dart';

/// Device can be set directly to specified state,
/// which is represented as [Scene].
class Scene {
  /// Class of scene.
  ///
  /// See:
  /// * [SceneClass.color]
  /// * [SceneClass.hsv]
  /// * [SceneClass.colorTemperature]
  /// * [SceneClass.colorFlow]
  /// * [SceneClass.autoDelayOff]
  final SceneClass sceneClass;

  /// [sceneClass] specific value.
  ///
  /// Represents:
  /// * color - when [sceneClass] is [SceneClass.color]
  /// * hue - when [sceneClass] is [SceneClass.hsv]
  /// * color temperature - when [sceneClass] is [SceneClass.colorTemperature]
  /// * brightness - when [sceneClass] is [SceneClass.autoDelayOff]
  /// * ignored - when [sceneClass] is [SceneClass.colorFlow]
  final int val1;

  /// [sceneClass] specific value.
  ///
  /// Represents:
  /// * brightness - when [sceneClass] is [SceneClass.color]
  /// * saturation - when [sceneClass] is [SceneClass.hsv]
  /// * brightness - when [sceneClass] is [SceneClass.colorTemperature]
  /// * timer (minutes) - when [sceneClass] is [SceneClass.autoDelayOff]
  /// * ignored - when [sceneClass] is [SceneClass.colorFlow]
  final int val2;

  /// [sceneClass] specific value.
  ///
  /// Represents:
  /// * brightness - when [sceneClass] is [SceneClass.hsv]
  /// * [Flow.expression] - when [sceneClass] is [SceneClass.colorFlow]
  final String val3;

  const Scene({this.sceneClass, this.val1 = 0, this.val2 = 0, this.val3});

  /// Change the device to specified [color] and [brightness].
  Scene.color({@required Color color, @required int brightness})
      : this(
          sceneClass: const SceneClass.color(),
          val1: color.value,
          val2: brightness,
        );

  /// Change the device to specified [color] and [brightness].
  const Scene.hsv({
    @required int hue,
    @required int saturation,
    @required int brightness,
  }) : this(
          sceneClass: const SceneClass.hsv(),
          val1: hue,
          val2: saturation,
          val3: "$brightness",
        );

  /// Change the device to specified [colorTemperature] and [brightness].
  const Scene.colorTemperature({
    @required int colorTemperature,
    @required int brightness,
  }) : this(
          sceneClass: const SceneClass.colorTemperature(),
          val1: colorTemperature,
          val2: brightness,
        );

  /// Start a color [flow] in specified style.
  Scene.colorFlow({@required Flow flow})
      : this(sceneClass: const SceneClass.colorFlow(), val3: flow.expression);

  /// Turn on the device to specified [brightness] and start a [timer] to
  /// turn off the light after specified number of minutes.
  Scene.autoDelayOff({
    @required int brightness,
    @required Duration timer,
  }) : this(
          sceneClass: const SceneClass.autoDelayOff(),
          val1: brightness,
          val2: timer.inMinutes,
        );

  @override
  int get hashCode =>
      sceneClass.hashCode ^ val1.hashCode ^ val2.hashCode ^ val3.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Scene &&
            runtimeType == other.runtimeType &&
            sceneClass == other.sceneClass &&
            val1 == other.val1 &&
            val2 == other.val2 &&
            val3 == other.val3;
  }

  @override
  String toString() => "Scene(sceneClass: ${sceneClass.value}, val1: $val1,"
      "val2: $val2, val3: $val3)";
}
