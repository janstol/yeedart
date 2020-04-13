import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

// ignore: avoid_classes_with_only_static_members
class Fixtures {
  static String loadFile(String name) =>
      File('$_testDirectory/fixtures/$name').readAsStringSync();

  static Map<String, dynamic> loadJson(String name) => getJson(loadFile(name));

  static Map<String, dynamic> getJson(String jsonValue) {
    return json.decode(jsonValue) as Map<String, dynamic>;
  }

  static const discoveryResponseRaw = 'HTTP/1.1 200 OK\r\n'
      'Cache-Control: max-age=3600\r\n'
      'Date: \r\n'
      'Ext: \r\n'
      'Location: yeelight://192.168.1.239:55443\r\n'
      'Server: POSIX UPnP/1.0 YGLC/1\r\n'
      'id: 0x000000000015243f\r\n'
      'model: color\r\n'
      'fw_ver: 18\r\n'
      'support: get_prop set_default set_power toggle set_bright start_cf '
      'stop_cf set_scene cron_add cron_get cron_del set_ct_abx set_rgb\r\n'
      'power: on\r\n'
      'bright: 100\r\n'
      'color_mode: 2\r\n'
      'ct: 4000\r\n'
      'rgb: 16711680\r\n'
      'hue: 100\r\n'
      'sat: 35\r\n'
      'name: my_bulb'
      '\r\n';

  // From https://github.com/flutter/flutter/issues/20907#issuecomment-466185328
  static final String _testDirectory = join(
    Directory.current.path,
    Directory.current.path.endsWith('test') ? '' : 'test',
  );
}
