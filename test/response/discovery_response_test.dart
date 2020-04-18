import 'dart:io';

import 'package:test/test.dart';
import 'package:yeedart/src/response/discovery_response.dart';

import '../fixtures/fixtures.dart';

void main() {
  test('should parse raw response', () {
    final discoveryResponse = DiscoveryResponse(
      refreshInterval: 3600,
      address: InternetAddress('192.168.1.239'),
      port: 55443,
      id: 0x000000000015243f,
      model: 'color',
      firmwareVersion: 18,
      supportedControls: [
        'get_prop',
        'set_default',
        'set_power',
        'toggle',
        'set_bright',
        'start_cf',
        'stop_cf',
        'set_scene',
        'cron_add',
        'cron_get',
        'cron_del',
        'set_ct_abx set_rgb',
      ],
      powered: true,
      brightness: 100,
      colorMode: 2,
      colorTemperature: 4000,
      rgb: 16711680,
      hue: 100,
      sat: 35,
      name: 'my_bulb',
      rawResponse: Fixtures.discoveryResponseRaw,
    );

    expect(
      DiscoveryResponse.fromRawResponse(Fixtures.discoveryResponseRaw),
      discoveryResponse,
    );
  });

  test('hashCode returns correct value', () {
    final response =
        DiscoveryResponse.fromRawResponse(Fixtures.discoveryResponseRaw);

    expect(
      response.hashCode,
      response.rawResponse.hashCode ^ response.runtimeType.hashCode,
    );
  });

  test('toString returns correct value', () {
    final response =
        DiscoveryResponse.fromRawResponse(Fixtures.discoveryResponseRaw);
    expect(response.toString(), _toString(response));
  });
}

String _toString(DiscoveryResponse response) {
  return 'DiscoveryResponse(refreshInterval: ${response.refreshInterval}, '
      'ipAddress: ${response.address}, '
      'port: ${response.port}, id: ${response.id}, '
      'model: ${response.model}, '
      'firmwareVersion: ${response.firmwareVersion}, '
      'supportedControls: <${response.supportedControls}>, '
      'powered: ${response.powered}, '
      'brightness: ${response.brightness}, colorMode: ${response.colorMode}, '
      'colorTemperature: ${response.colorTemperature}, rgb: ${response.rgb}, '
      'hue: ${response.hue}, sat: ${response.sat}, '
      'name: ${response.name})';
}
