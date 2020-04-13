# Yeedart

[![Pub](https://img.shields.io/pub/v/yeedart.svg?style=flat-square)](https://pub.dartlang.org/packages/yeedart)
[![Build Status](https://travis-ci.com/janstol/yeedart.svg?branch=master)](https://travis-ci.com/janstol/yeedart)

Dart library for controlling Yeelight products over LAN.

More info about Yeelight API:
* https://www.yeelight.com/en_US/developer
* https://www.yeelight.com/download/Yeelight_Inter-Operation_Spec.pdf

## Contents
* [Installation](#installation)
* Usage
  - [Device discovery](#device-discovery)
  - [Connect to the device](#connect-to-the-device)
  - [Main and background light](#main-and-background-light)
* [Flow](#flow)
* [Scene](#scene)
* [Features and bugs](#features-and-bugs)

## Installation

1. **Depend on it**

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  yeedart: ^0.2.0
```
2. **Install it**

You can install packages from the command line:

with pub:
```
$ pub get
```
or with flutter:
```
$ flutter pub get
```
Alternatively, your editor might support `pub get` or `flutter pub get`. Check the docs for your editor to learn more.

3. **Import it**

Now in your Dart code, you can use:
```dart
import 'package:yeedart/yeedart.dart';
```

## Usage

### Device discovery
First of all, you need to know your device's IP address and port. 
You can use `Yeelight.discover()` method which returns list of `DiscoveryResponse`.

```dart
final responses = await Yeelight.discover();
final response = responses.first; // or filter..
```
Each response contains IP address and port for given device 
and other properties (name, firmware version, current state,...).

:information_source: You can also specify timeout for discovery. Default is 2 seconds.

### Connect to the device

```dart
final device = Device(
  address: InternetAddress("192.168.1.183"),
  port: 55443,
);

await device.turnOn(); // turn the device on

// set red color with smooth transition
await device.setRGB(
  color: Colors.red,
  effect: const Effect.smooth(),
  duration: const Duration(milliseconds: 500),
);

await device.setBrightness(brightness: 70); // set brightness to 70 %

device.disconnect(); // always disconnect when you are done!
```

:warning: When you instantiate `Device`, new TCP connection is created automatically.
This single TCP connection is then used for every command. So when you are done,
**you should close the connection**.

:information_source: Note that when call `device.disconnect()` and then call 
for example `device.turnOff()`, new TCP connection will be created automatically.

:information_source: Also note that Yeelight connections are rate-limited to 60 per minute.

### Main and background light
Some devices can be equiped with two lights: main and background. Methods in `Device` class control main light by default
(for example `device.setRGB(color: Colors.red)` sets RGB color for main light. If you want to set RGB color for background light, you have to specify `lightType` parameter: `device.setRGB(color: Colors.red, lightType: LightType.backgroud);`.

You can also use `LightType.both` but **ONLY** for toggling: `device.toggle(lightType: LightType.both)`.

## Flow
Flow (color flow) is basically a list of transitions. To start a flow use `startFlow()` method and provide `Flow`. `Flow` has 3 required parameters:
* count - number of transitions to run, 0 for infinite loop. If you have 10 transitions and count is 5, it will run only first 5 transitions!
* action - specifies action to take after the flow ends.
  * `FlowAction.stay` to stay at the last state when the flow is stopped.
  * `FlowAction.recover` to recover the state before the flow.
  * `FlowAction.turnOff` to turn off.
* transitions - list of `FlowTransition`, `FlowTransition.rgb()`, `FlowTransition.colorTemperature()` or `FlowTransition.sleep()`.

Following example will loop red, green and blue colors at full brightness.
```dart
await device.startFlow(
  flow: const Flow(
    count: 0,
    action: FlowAction.recover(),
    transitions: [
      FlowTransition.rgb(color: 0xff0000, brightness: 100),
      FlowTransition.sleep(duration: Duration(milliseconds: 500)),
      FlowTransition.rgb(color: 0x00ff00, brightness: 100),
      FlowTransition.sleep(duration: Duration(milliseconds: 500)),
      FlowTransition.rgb(color: 0x0000ff, brightness: 100),
      FlowTransition.sleep(duration: Duration(milliseconds: 500)),
    ],
  ),
);
```
To manually stop flow, use `device.stopFlow()`.

This library also includes some predefined flows:
* `Flow.rgb()` - changes color from red, to green to blue
* `Flow.police` - changes red and blue color like police lights.
* `Flow.pulse()` - creates pulse with given color

## Scene
Scene allows you to set light to specific state. To use scene, use `setScene()` method and provide `Scene`.

You can use:
* `Scene.color()` or `Scene.hsv()` to set color and brightness
* `Scene.colorTemperature` to set color temperature and brightness
* `Scene.colorFlow()` to start a color [Flow](#flow)
* `Scene.autoDelayOff()` to turn on the device to specified brightness and start a timer to turn off the light after specified number of minutes.

Example:
```dart
device.setScene(scene: Scene.color(color: 0xff0000, brightness: 100));
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/janstol/yeedart/issues/
