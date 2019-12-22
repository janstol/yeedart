import 'package:yeedart/src/util/enum.dart';

class AdjustProperty extends Enum<String> {
  const AdjustProperty.brightness() : this._('bright');

  const AdjustProperty.color() : this._('color');

  const AdjustProperty.colorTemperature() : this._('ct');

  const AdjustProperty._(String value) : super(value);
}
