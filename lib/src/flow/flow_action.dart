import 'package:yeedart/src/util/enum.dart';

/// Action used in [Flow].
///
/// See [Flow.action].
class FlowAction extends Enum<int> {
  const FlowAction.recover() : this._(0);

  const FlowAction.stay() : this._(1);

  const FlowAction.turnOff() : this._(2);

  const FlowAction._(int value) : super(value);
}
