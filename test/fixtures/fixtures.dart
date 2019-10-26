import 'dart:io';

import 'package:path/path.dart';

String fixture(String name) =>
    File("$_testDirectory/fixtures/$name").readAsStringSync();

String discoveryMessage(InternetAddress address, int port) {
  return "M-SEARCH * HTTP/1.1\r\n"
      "HOST: ${address.address}:$port\r\n"
      "MAN: \"ssdp:discover\"\r\n"
      "ST: wifi_bulb\r\n";
}

// From https://github.com/flutter/flutter/issues/20907#issuecomment-466185328
final _testDirectory = join(
  Directory.current.path,
  Directory.current.path.endsWith('test') ? '' : 'test',
);
