/// Type of light.
enum LightType {
  /// Main light.
  main,

  /// Background light.
  ///
  /// NOTE: Some devices don't have a background light.
  backgroud,

  /// Main and background light (
  /// NOTE: used only for toggling.
  both,
}
