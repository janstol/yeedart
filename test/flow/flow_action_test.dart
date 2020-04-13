import 'package:test/test.dart';
import 'package:yeedart/src/flow/flow_action.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('flow actions equality', () {
    expect(FlowAction.recover(), FlowAction.recover());
    expect(FlowAction.recover(), isNot(FlowAction.stay()));
    expect(FlowAction.stay(), isNot(FlowAction.turnOff()));
  });

  test('toString() returns correct value', () {
    final action = FlowAction.recover();
    expect(action.toString(), 'FlowAction(${action.value})');
  });
}
