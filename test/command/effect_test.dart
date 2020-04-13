import 'package:test/test.dart';
import 'package:yeedart/src/command/enum/effect.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('effects equality', () {
    expect(Effect.smooth(), Effect.smooth());
    expect(Effect.smooth(), isNot(Effect.sudden()));
  });

  test('toString returns correct value', () {
    final effect = Effect.sudden();
    expect(effect.toString(), 'Effect(${effect.value})');
  });
}
