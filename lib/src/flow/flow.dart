import 'package:meta/meta.dart';
import 'package:yeedart/src/command/color.dart';
import 'package:yeedart/src/command/color_temperature.dart';
import 'package:yeedart/src/flow/flow_transition.dart';
import 'package:yeedart/src/util/enum.dart';

/// Flow used when starting color flow.
///
/// See [Device.startFlow].
class Flow {
  /// Total number of times to run this flow.
  ///
  /// 0 = infinite loop.
  final int count;

  /// Action to take after the flow ends.
  ///
  /// * [FlowAction.stay] to stay at the last state when the flow is stopped.
  /// * [FlowAction.recover] to recover the state before the flow.
  /// * [FlowAction.turnOff] to turn off.
  final FlowAction action;

  /// List of [FlowTransition].
  ///
  /// Describes the flow.
  final List<FlowTransition> transitions;

  const Flow({
    @required this.count,
    @required this.action,
    @required this.transitions,
  });

  /// Flow preset - changes color from red, to green to blue.
  Flow.rgb({
    int count = 1,
    FlowAction action = const FlowAction.recover(),
    int brightness = 100,
    Duration duration = const Duration(milliseconds: 250),
    Duration sleepDuration = const Duration(milliseconds: 2500),
  }) : this(
          count: count,
          action: action,
          transitions: [
            FlowTransition.rgb(
              duration: duration,
              color: Colors.red.value,
              brightness: brightness,
            ),
            FlowTransition.sleep(duration: sleepDuration),
            FlowTransition.rgb(
              duration: duration,
              color: Colors.green.value,
              brightness: brightness,
            ),
            FlowTransition.sleep(duration: sleepDuration),
            FlowTransition.rgb(
              duration: duration,
              color: Colors.blue.value,
              brightness: brightness,
            ),
            FlowTransition.sleep(duration: sleepDuration),
          ],
        );

  /// Flow preset - changes color temperature from [start] to [end].
  Flow.temperature({
    ColorTemperature start = const ColorTemperature(1700),
    ColorTemperature end = const ColorTemperature(6500),
    int count = 1,
    FlowAction action = const FlowAction.turnOff(),
    int brightness = 100,
    Duration duration = const Duration(seconds: 15),
  }) : this(
          count: count,
          action: action,
          transitions: [
            FlowTransition.colorTemperature(
              colorTemperature: start.value,
              brightness: brightness,
              duration: duration,
            ),
            FlowTransition.colorTemperature(
              colorTemperature: end.value,
              brightness: brightness,
              duration: duration,
            ),
          ],
        );

  /// Flow preset - creates pulse with given [color].
  Flow.pulse({
    @required Color color,
    int count = 1,
    FlowAction action = const FlowAction.turnOff(),
    int brightness = 100,
    Duration duration = const Duration(milliseconds: 250),
  }) : this(
          count: count,
          action: action,
          transitions: [
            FlowTransition.rgb(
              duration: duration,
              color: color.value,
              brightness: brightness,
            ),
            FlowTransition.rgb(
              duration: duration,
              color: color.value,
              brightness: 1,
            ),
          ],
        );

  /// Flow preset - changing red and blue color like police lights.
  Flow.police({
    int count = 1,
    FlowAction action = const FlowAction.turnOff(),
    int brightness = 100,
    Duration duration = const Duration(milliseconds: 250),
  }) : this(
          count: count,
          action: action,
          transitions: [
            FlowTransition.rgb(
              duration: duration,
              color: Colors.red.value,
              brightness: brightness,
            ),
            FlowTransition.rgb(
              duration: duration,
              color: Colors.blue.value,
              brightness: brightness,
            ),
          ],
        );

  /// Returns expression that can be sent to the device.
  String get expression => transitions
      .map((t) {
        return "${t.duration.inMilliseconds},${t.mode.value},${t.value},"
            "${t.brightness}";
      })
      .toList()
      .join(",");

  @override
  int get hashCode => count.hashCode ^ action.hashCode ^ transitions.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Flow &&
            count == other.count &&
            action == other.action &&
            transitions == other.transitions;
  }

  @override
  String toString() => "Flow(count: $count, action: $action, "
      "transitions: $transitions)";
}

/// Action used in [Flow].
///
/// See [Flow.action].
class FlowAction extends Enum<int> {
  const FlowAction.recover() : this._(0);

  const FlowAction.stay() : this._(1);

  const FlowAction.turnOff() : this._(2);

  const FlowAction._(int value) : super(value);
}
