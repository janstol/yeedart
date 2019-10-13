import 'dart:io';

import 'package:yeedart/src/domain/entity/yee_device.dart';
import 'package:yeedart/yeedart.dart';

Future<void> main() async {
  //final devices = await Yeelight.dicoverDevices();
  //final device = devices.first;
  final device = YeeDevice(
    address: InternetAddress("192.168.1.183"),
    port: 55443,
  );

  print(device);

  print(await device.getProps(id: 1, parameters: [
    "id",
    "name",
    "model",
    "fw_ver",
    "power",
    "support",
    "color_mode",
    "bright",
    "ct",
    "rgb",
    "hue",
    "sat",
  ]));

  device.disconnect();
}
