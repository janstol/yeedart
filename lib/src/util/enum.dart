/// Emulation of Java Enum class.
abstract class Enum<T> {
  final T _value;

  const Enum(this._value);

  T get value => _value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Enum<T> && value == other.value;
  }

  @override
  String toString() => "Enum($value)";
}
