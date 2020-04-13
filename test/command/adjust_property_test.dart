import 'package:test/test.dart';
import 'package:yeedart/src/command/enum/adjust_property.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('properties equality', () {
    expect(AdjustProperty.brightness(), AdjustProperty.brightness());
    expect(AdjustProperty.brightness(), isNot(AdjustProperty.color()));
    expect(AdjustProperty.color(), isNot(AdjustProperty.colorTemperature()));
  });

  test('toString returns correct value', () {
    final brightness = AdjustProperty.brightness();
    expect(brightness.toString(), 'AdjustProperty(${brightness.value})');
  });
}
