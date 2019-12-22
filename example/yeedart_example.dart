import 'dart:io';

import 'package:yeedart/yeedart.dart';

Future<void> main() async {
  // Discover devices
//  final responses = await Yeelight.discover();
//  final response = responses.first;
//  final device = Device(address: response.address, port: response.port);
//  device.turnOn();
//  await Future<void>.delayed(const Duration(seconds: 3));
//  device.turnOff();
//  device.disconnect();

  // Connect directly to device
  final device = Device(
    address: InternetAddress('192.168.1.183'),
    port: 55443,
  );

  // ignore: avoid_print
  print(await device.getProps(id: 1, parameters: [
    'name',
    'model',
    'fw_ver',
    'power',
    'color_mode',
    'bright',
    'ct',
    'rgb',
    'hue',
    'sat',
  ]));

  await device.turnOn();
  await Future<void>.delayed(const Duration(seconds: 3));
  await device.turnOff();
  device.disconnect();
}
