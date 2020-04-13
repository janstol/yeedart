import 'package:test/test.dart';
import 'package:yeedart/src/scene/scene_class.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('scene classes equality', () {
    expect(SceneClass.autoDelayOff(), SceneClass.autoDelayOff());
    expect(SceneClass.autoDelayOff(), isNot(SceneClass.color()));
    expect(SceneClass.color(), isNot(SceneClass.colorFlow()));
    expect(SceneClass.colorFlow(), isNot(SceneClass.colorTemperature()));
    expect(SceneClass.colorTemperature(), isNot(SceneClass.hsv()));
  });

  test('toString() returns correct value', () {
    final cls = SceneClass.color();
    expect(cls.toString(), 'SceneClass(${cls.value})');
  });
}
