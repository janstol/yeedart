import 'package:yeedart/src/util/enum.dart';

/// Type of effect.
class Effect extends Enum<String> {
  /// Property (color, color temperature,...) will be changed gradually to
  /// target value.
  const Effect.smooth() : this._("smooth");

  /// Property (color, color temperature,..)
  /// will be changed directly to target value.
  const Effect.sudden() : this._("sudden");

  const Effect._(String value) : super(value);
}
