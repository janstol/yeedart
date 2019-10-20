/// Color temperature used for Yeelight device lights.
class ColorTemperature {
  /// Color temperature value (1700-6500).
  final int value;

  /// Construct color temperature with given [value].
  const ColorTemperature(this.value);

  const ColorTemperature.matchFlame() : this(1700);

  const ColorTemperature.candle() : this(1900);

  const ColorTemperature.dimIncandescent() : this(2300);

  const ColorTemperature.incandescent() : this(2700);

  const ColorTemperature.halogen() : this(3400);

  const ColorTemperature.fluorescent() : this(4200);

  const ColorTemperature.sunlight() : this(5500);

  const ColorTemperature.daylight() : this(6500);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ColorTemperature && value == other.value;
  }

  @override
  String toString() => "ColorTemperature($value)";
}
