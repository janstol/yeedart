import 'dart:io';

import 'package:yeedart/yeedart.dart';

Future<void> main() async {
//  final responses = await Yeelight.discover();
//  final response = responses.first;
//
//  final device = YeeDevice(address: response.address, port: response.port);

  final device = Device(
    address: InternetAddress("192.168.1.183"),
    port: 55443,
  );

  print(await device.getProps(id: 1, parameters: [
    "name",
    "model",
    "fw_ver",
    "power",
    "color_mode",
    "bright",
    "ct",
    "rgb",
    "hue",
    "sat",
  ]));

  //await device.turnOn();
  //await device.turnOff();
  //await device.setScene(scene: Scene.color(color: Colors.red, brightness: 20));
  //await device.stopFlow();
  device.disconnect();
}
