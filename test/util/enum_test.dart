import 'package:test/test.dart';
import 'package:yeedart/src/util/enum.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('enum values equals', () {
    expect(TestEnum.valueOne(), TestEnum.valueOne());
    expect(TestEnum.valueOne(), isNot(TestEnum.valueTwo()));
  });

  test('toString returns correct value', () {
    final valueOne = TestEnum.valueOne();
    expect(valueOne.toString(), 'TestEnum(${valueOne.value})');
  });
}

class TestEnum extends Enum<String> {
  const TestEnum.valueOne() : this._('string');

  const TestEnum.valueTwo() : this._('two');

  const TestEnum.valueThree() : this._('three');

  const TestEnum._(String value) : super(value);
}
