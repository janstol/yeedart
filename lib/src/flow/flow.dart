import 'package:meta/meta.dart';
import 'package:yeedart/src/flow/flow_action.dart';
import 'package:yeedart/src/flow/flow_transition.dart';
import 'package:yeedart/src/util/enum.dart';
import 'package:collection/collection.dart';

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
              color: 0xff0000,
              brightness: brightness,
            ),
            FlowTransition.sleep(duration: sleepDuration),
            FlowTransition.rgb(
              duration: duration,
              color: 0x00ff00,
              brightness: brightness,
            ),
            FlowTransition.sleep(duration: sleepDuration),
            FlowTransition.rgb(
              duration: duration,
              color: 0x0000ff,
              brightness: brightness,
            ),
            FlowTransition.sleep(duration: sleepDuration),
          ],
        );

  /// Flow preset - changes color temperature from [start] to [end].
  Flow.temperature({
    int start = 1700,
    int end = 6500,
    int count = 1,
    FlowAction action = const FlowAction.turnOff(),
    int brightness = 100,
    Duration duration = const Duration(seconds: 15),
  }) : this(
          count: count,
          action: action,
          transitions: [
            FlowTransition.colorTemperature(
              colorTemperature: start,
              brightness: brightness,
              duration: duration,
            ),
            FlowTransition.colorTemperature(
              colorTemperature: end,
              brightness: brightness,
              duration: duration,
            ),
          ],
        );

  /// Flow preset - creates pulse with given [color].
  Flow.pulse({
    @required int color,
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
              color: color,
              brightness: brightness,
            ),
            FlowTransition.rgb(
              duration: duration,
              color: color,
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
              color: 0xff0000,
              brightness: brightness,
            ),
            FlowTransition.rgb(
              duration: duration,
              color: 0x0000ff,
              brightness: brightness,
            ),
          ],
        );

  /// Returns expression that can be sent to the device.
  String get expression => transitions
      .map((t) {
        return '${t.duration.inMilliseconds},${t.mode.value},${t.value},'
            '${t.brightness}';
      })
      .toList()
      .join(',');

  static const _listEquality = ListEquality<FlowTransition>();

  @override
  int get hashCode => count.hashCode ^ action.hashCode ^ transitions.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Flow &&
            runtimeType == other.runtimeType &&
            count == other.count &&
            action == other.action &&
            _listEquality.equals(transitions, other.transitions);
  }

  @override
  String toString() => 'Flow(count: $count, action: $action, '
      'transitions: $transitions)';
}
