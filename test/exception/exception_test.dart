import 'package:test/test.dart';
import 'package:yeedart/src/exception/exception.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  group('YeelightConnectionException', () {
    final exception = YeelightConnectionException('Message');

    test('hashCode returns correct value', () {
      expect(
        exception.hashCode,
        exception.message.hashCode ^ exception.runtimeType.hashCode,
      );
    });

    test('YeelightConnectionException equality', () {
      expect(exception, YeelightConnectionException('Message'));
      expect(exception, isNot(YeelightConnectionException('Other')));
    });

    test('toString() returns correct value', () {
      expect(
        exception.toString(),
        'YeelightConnectionException: ${exception.message}',
      );
    });
  });
}
