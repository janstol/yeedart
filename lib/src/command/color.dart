/// Color used for Yeelight device lights.
class Color {
  final int value;

  /// Construct color from a 24-bit int [value].
  const Color(int value) : value = value & 0xFFFFFF;

  /// Construct color from [r], [g] and [b] int values, each in range 0-255.
  const Color.fromRGB(int r, int g, int b)
      : value = (((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0)) &
            0xFFFFFF;

  /// The red channel of this color.
  int get red => (0xFF0000 & value) >> 16;

  /// The green channel of this color.
  int get green => (0x00FF00 & value) >> 8;

  /// The blue channel of this color.
  int get blue => (0x0000FF & value) >> 0;

  /// Returns this color value as hex string.
  String get hexValue => value.toRadixString(16).padLeft(6, "0").toUpperCase();

  /// Returns a new color that matches this color with the red channel
  /// replaced with [r] (which ranges from 0 to 255).
  Color withRed(int r) => Color.fromRGB(r, green, blue);

  /// Returns a new color that matches this color with the green channel
  /// replaced with [g] (which ranges from 0 to 255).
  Color withGreen(int g) => Color.fromRGB(red, g, blue);

  /// Returns a new color that matches this color with the blue channel
  /// replaced with [b] (which ranges from 0 to 255).
  Color withBlue(int b) => Color.fromRGB(red, green, b);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Color &&
            runtimeType == other.runtimeType &&
            value == other.value;
  }

  @override
  String toString() => "Color(0x$hexValue)";
}

/// Predefined colors.
abstract class Colors {
  static const Color white = Color(0xFFFFFF);
  static const Color red = Color(0xFF0000);
  static const Color green = Color(0x00FF00);
  static const Color blue = Color(0x0000FF);
  static const Color yellow = Color(0xFFFF00);
  static const Color orange = Color(0xFFA500);
  static const Color cyan = Color(0x00FFFF);
  static const Color magenta = Color(0xFF00FF);
}
