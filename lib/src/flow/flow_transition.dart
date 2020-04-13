import 'package:meta/meta.dart';
import 'package:yeedart/src/flow/flow_transition_mode.dart';

/// Transition used in [Flow].
class FlowTransition {
  /// Duration of transition
  /// or sleep time when [mode] is [FlowTransitionMode.sleep]
  ///
  /// Minimum is 50 milliseconds.
  final Duration duration;

  /// Mode which will be used for transition;
  ///
  /// * [FlowTransitionMode.color]
  /// * [FlowTransitionMode.colorTemperature]
  /// * or [FlowTransitionMode.sleep]
  final FlowTransitionMode mode;

  /// Color when [mode] is [FlowTransitionMode.color] or color temperature when
  /// [mode] is [FlowTransitionMode.colorTemperature].
  ///
  /// Value is ignored when [mode] is [FlowTransitionMode.sleep].
  final int value;

  /// Brightness value from 1 to 100. When set to -1, brightness is ignored.
  /// Ignored when when [mode] is [FlowTransitionMode.sleep]
  final int brightness;

  /// Creates [FlowTransition].
  const FlowTransition({this.duration, this.mode, this.value, this.brightness});

  /// Creates [FlowTransition] with RGB value and brightness.
  const FlowTransition.rgb({
    Duration duration = const Duration(milliseconds: 500),
    @required int color,
    @required int brightness,
  }) : this(
          duration: duration,
          mode: const FlowTransitionMode.color(),
          value: color,
          brightness: brightness,
        );

  /// Creates [FlowTransition] with color temperature and brightness.
  const FlowTransition.colorTemperature({
    Duration duration = const Duration(milliseconds: 500),
    @required int colorTemperature,
    @required int brightness,
  }) : this(
          duration: duration,
          mode: const FlowTransitionMode.colorTemperature(),
          value: colorTemperature,
          brightness: brightness,
        );

  /// Creates sleep transition.
  const FlowTransition.sleep({
    Duration duration = const Duration(milliseconds: 500),
  }) : this(
          duration: duration,
          mode: const FlowTransitionMode.sleep(),
          value: 0,
          brightness: 0,
        );

  @override
  int get hashCode =>
      duration.hashCode ^ mode.hashCode ^ value.hashCode ^ brightness.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FlowTransition &&
            runtimeType == other.runtimeType &&
            duration == other.duration &&
            mode == other.mode &&
            value == other.value &&
            brightness == other.brightness;
  }

  @override
  String toString() => 'FlowTransition(duration: $duration, mode: $mode, '
      'value: $value, brightness: $brightness)';
}
