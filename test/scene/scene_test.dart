import 'package:test/test.dart';
import 'package:yeedart/src/flow/flow.dart';
import 'package:yeedart/src/scene/scene.dart';
import 'package:yeedart/src/scene/scene_class.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  test('Scene.color()', () {
    expect(
      Scene.color(color: 255, brightness: 50),
      Scene(sceneClass: SceneClass.color(), val1: 255, val2: 50),
    );
  });

  test('Scene.hsv()', () {
    expect(
      Scene.hsv(hue: 30, saturation: 100, brightness: 70),
      Scene(sceneClass: SceneClass.hsv(), val1: 30, val2: 100, val3: '70'),
    );
  });

  test('Scene.colorTemperature()', () {
    expect(
      Scene.colorTemperature(colorTemperature: 1700, brightness: 80),
      Scene(sceneClass: SceneClass.colorTemperature(), val1: 1700, val2: 80),
    );
  });

  test('Scene.colorFlow()', () {
    final flow = Flow.rgb();
    expect(
      Scene.colorFlow(flow: flow),
      Scene(sceneClass: SceneClass.colorFlow(), val3: flow.expression),
    );
  });

  test('Scene.autoDelayOff()', () {
    final timer = Duration(hours: 1);
    expect(
      Scene.autoDelayOff(brightness: 50, timer: timer),
      Scene(
        sceneClass: SceneClass.autoDelayOff(),
        val1: 50,
        val2: timer.inMinutes,
      ),
    );
  });

  test('hashCode returns correct value', () {
    final scene = Scene.color(color: 255, brightness: 50);
    expect(
      scene.hashCode,
      scene.sceneClass.hashCode ^
          scene.val1.hashCode ^
          scene.val2.hashCode ^
          scene.val3.hashCode,
    );
  });

  test('toString() returns correct value', () {
    final scene = Scene.color(color: 255, brightness: 50);
    expect(
      scene.toString(),
      'Scene(sceneClass: ${scene.sceneClass.value}, val1: ${scene.val1}, '
      'val2: ${scene.val2}, val3: ${scene.val3})',
    );
  });
}
