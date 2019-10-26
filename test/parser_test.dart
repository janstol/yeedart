import 'dart:io';

import 'package:test/test.dart';
import 'package:yeedart/src/response/discovery_response.dart';
import 'package:yeedart/src/util/parser.dart';

import 'fixtures/fixtures.dart';

void main() {
  final discoveryResponse = DiscoveryResponse(
    refreshInterval: 3600,
    address: InternetAddress("192.168.1.239"),
    port: 55443,
    id: 0x000000000015243f,
    model: "color",
    firmwareVersion: 18,
    supportedControls: [
      "get_prop",
      "set_default",
      "set_power",
      "toggle",
      "set_bright",
      "start_cf",
      "stop_cf",
      "set_scene",
      "cron_add",
      "cron_get",
      "cron_del",
      "set_ct_abx set_rgb",
    ],
    powered: true,
    brightness: 100,
    colorMode: 2,
    colorTemperature: 4000,
    rgb: 16711680,
    hue: 100,
    sat: 35,
    name: "my_bulb",
    rawResponse: discoveryResponseRaw,
  );

  test('should parse discovery respose', () {
    final parsed = Parser.parseDiscoveryResponse(discoveryResponseRaw);
    expect(DiscoveryResponse.fromMap(parsed), discoveryResponse);
  });
}
