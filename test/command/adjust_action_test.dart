import 'package:test/test.dart';
import 'package:yeedart/src/command/enum/adjust_action.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('actions equality', () {
    expect(AdjustAction.circle(), AdjustAction.circle());
    expect(AdjustAction.circle(), isNot(AdjustAction.increase()));
    expect(AdjustAction.increase(), isNot(AdjustAction.decrease()));
  });

  test('toString returns correct value', () {
    final circle = AdjustAction.circle();
    expect(circle.toString(), 'AdjustAction(${circle.value})');
  });
}
