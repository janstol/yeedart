import 'package:test/test.dart';
import 'package:yeedart/src/flow/flow.dart';
import 'package:yeedart/src/flow/flow_action.dart';
import 'package:yeedart/src/flow/flow_transition.dart';
import 'package:yeedart/src/flow/flow_transition_mode.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('Flow.rgb()', () {
    const duration = Duration(milliseconds: 250);
    const sleepDuration = Duration(milliseconds: 2500);
    const count = 2;
    const brightness = 50;

    expect(
      Flow.rgb(
        count: count,
        action: FlowAction.recover(),
        brightness: brightness,
        duration: duration,
        sleepDuration: sleepDuration,
      ),
      Flow(
        count: count,
        action: FlowAction.recover(),
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
      ),
    );
  });

  test('Flow.temperature()', () {
    const start = 1700;
    const end = 6500;
    const count = 1;
    const brightness = 50;
    const duration = Duration(seconds: 10);

    expect(
      Flow.temperature(
        start: start,
        end: end,
        count: count,
        action: FlowAction.turnOff(),
        brightness: brightness,
        duration: duration,
      ),
      Flow(
        count: count,
        action: FlowAction.turnOff(),
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
      ),
    );
  });

  test('Flow.pulse()', () {
    const color = 0xFFFFFF;
    const count = 5;
    const brightness = 70;
    const duration = Duration(microseconds: 250);

    expect(
      Flow.pulse(
        color: color,
        count: count,
        action: FlowAction.turnOff(),
        brightness: brightness,
        duration: duration,
      ),
      Flow(
        count: count,
        action: FlowAction.turnOff(),
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
      ),
    );
  });

  test('Flow.police()', () {
    const count = 10;
    const brightness = 70;
    const duration = Duration(milliseconds: 250);

    expect(
      Flow.police(
        count: count,
        action: FlowAction.turnOff(),
        brightness: brightness,
        duration: duration,
      ),
      Flow(
        count: count,
        action: FlowAction.turnOff(),
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
      ),
    );
  });

  test('returns correct expression', () {
    const count = 2;
    const brightness = 70;
    const mode = FlowTransitionMode.color();
    const duration = Duration(milliseconds: 250);

    final flow = Flow(
      count: count,
      action: FlowAction.turnOff(),
      transitions: [
        FlowTransition.rgb(
          duration: duration,
          color: 255,
          brightness: brightness,
        ),
        FlowTransition.rgb(
          duration: duration,
          color: 16711680,
          brightness: brightness,
        ),
      ],
    );

    final expression =
        '${duration.inMilliseconds},${mode.value},255,$brightness,'
        '${duration.inMilliseconds},${mode.value},16711680,$brightness';

    expect(flow.expression, expression);
  });

  test('toString() returns correct value', () {
    const count = 2;
    const brightness = 70;
    const mode = FlowTransitionMode.color();
    const duration = Duration(milliseconds: 250);

    final flow = Flow(
      count: count,
      action: FlowAction.turnOff(),
      transitions: [
        FlowTransition.rgb(
          duration: duration,
          color: 255,
          brightness: brightness,
        ),
        FlowTransition.rgb(
          duration: duration,
          color: 16711680,
          brightness: brightness,
        ),
      ],
    );

    expect(
      flow.toString(),
      'Flow(count: ${flow.count}, action: ${flow.action}, '
      'transitions: ${flow.transitions})',
    );
  });
}
