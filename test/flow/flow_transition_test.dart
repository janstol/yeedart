import 'package:test/test.dart';
import 'package:yeedart/src/flow/flow_transition.dart';
import 'package:yeedart/src/flow/flow_transition_mode.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('FlowTransition.rgb()', () {
    const color = 255;
    const brightness = 50;
    const duration = Duration(milliseconds: 250);

    expect(
      FlowTransition.rgb(
        color: color,
        brightness: brightness,
        duration: duration,
      ),
      FlowTransition(
        duration: duration,
        mode: FlowTransitionMode.color(),
        value: color,
        brightness: brightness,
      ),
    );
  });

  test('FlowTransition.colorTemperatur()', () {
    const colorTemperature = 1700;
    const brightness = 50;
    const duration = Duration(milliseconds: 250);

    expect(
      FlowTransition.colorTemperature(
        colorTemperature: colorTemperature,
        brightness: brightness,
        duration: duration,
      ),
      FlowTransition(
        duration: duration,
        mode: FlowTransitionMode.colorTemperature(),
        value: colorTemperature,
        brightness: brightness,
      ),
    );
  });

  test('FlowTransition.sleep()', () {
    const duration = Duration(milliseconds: 500);

    expect(
      FlowTransition.sleep(duration: duration),
      FlowTransition(
        duration: duration,
        mode: FlowTransitionMode.sleep(),
        value: 0,
        brightness: 0,
      ),
    );
  });

  test('toString() returns correct value', () {
    const color = 255;
    const brightness = 50;
    const duration = Duration(milliseconds: 250);

    final transition = FlowTransition.rgb(
      color: color,
      brightness: brightness,
      duration: duration,
    );

    expect(
      transition.toString(),
      'FlowTransition(duration: ${transition.duration}, '
      'mode: ${transition.mode}, value: ${transition.value}, '
      'brightness: ${transition.brightness})',
    );
  });
}
