import 'dart:io';

import 'package:test/test.dart';
import 'package:yeedart/src/response/discovery_response.dart';
import 'package:yeedart/src/yeelight.dart';

import 'fixtures/fixtures.dart';
import 'mocks/mock_raw_datagram_socket.dart';

void main() {
  test('discover() returns correct value', () async {
    expect(
      await Yeelight.discover(timeout: const Duration(milliseconds: 1)),
      <DiscoveryResponse>[],
    );

    expect(
      await Yeelight.discover(socket: MockRawDatagramSocket()),
      [DiscoveryResponse.fromRawResponse(Fixtures.discoveryResponseRaw)],
    );
  });

  test('createDiscoveryMessage() returns correct value', () {
    expect(
      Yeelight.createDiscoveryMessage(InternetAddress.loopbackIPv4, 1234),
      'M-SEARCH * HTTP/1.1\r\n'
      'HOST: ${InternetAddress.loopbackIPv4.address}:1234\r\n'
      'MAN: "ssdp:discover"\r\n'
      'ST: wifi_bulb\r\n',
    );
  });
}
