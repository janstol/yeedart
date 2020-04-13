import 'package:yeedart/src/util/enum.dart';

/// Mode for [FlowTransition].
class FlowTransitionMode extends Enum<int> {
  const FlowTransitionMode._(int value) : super(value);

  const FlowTransitionMode.color() : this._(1);

  const FlowTransitionMode.colorTemperature() : this._(2);

  const FlowTransitionMode.sleep() : this._(7);

  @override
  String toString() => 'FlowTransitionMode($value)';
}
