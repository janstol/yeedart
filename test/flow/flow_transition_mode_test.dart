import 'package:test/test.dart';
import 'package:yeedart/src/flow/flow_transition_mode.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('flow transition modes equality', () {
    expect(FlowTransitionMode.color(), FlowTransitionMode.color());
    expect(
      FlowTransitionMode.color(),
      isNot(FlowTransitionMode.colorTemperature()),
    );
    expect(
      FlowTransitionMode.colorTemperature(),
      isNot(FlowTransitionMode.sleep()),
    );
  });

  test('toString() returns correct value', () {
    final mode = FlowTransitionMode.color();
    expect(mode.toString(), 'FlowTransitionMode(${mode.value})');
  });
}
