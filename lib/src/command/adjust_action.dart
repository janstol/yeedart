import 'package:yeedart/src/util/enum.dart';

class AdjustAction extends Enum<String> {
  /// Increase the specified property, after it reaches the max value
  /// go back to minimum value.
  const AdjustAction.circle() : this._('circle');

  /// Decrease the specified property.
  const AdjustAction.decrease() : this._('decrease');

  /// Increase the specified property.
  const AdjustAction.increase() : this._('increase');

  const AdjustAction._(String value) : super(value);
}
