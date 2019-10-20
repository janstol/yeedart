# Yeedart

Dart library for controlling Yeelight products over LAN.

:exclamation: **package is still in development...** :exclamation:

## Contents
* [Installation](#installation)
* Usage
  - [Device discovery](#device-discovery)
  - [Connect to the device](#connect-to-the-device)
* [Flow](#flow)
* [Scene](#scene)
* [Features and bugs](#features-and-bugs)

## Installation

1. **Depend on it**

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  yeedart: ^0.0.0
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
:information_source: Also note that YeeLight connections are rate-limited to 60 per minute.

## Flow
todo

## Scene
todo

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/janstol/yeedart/issues/
