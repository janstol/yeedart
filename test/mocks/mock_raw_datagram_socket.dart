import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import '../fixtures/fixtures.dart';

class MockRawDatagramSocket extends RawDatagramSocket {
  bool broadcastEnabled = true;
  int multicastHops = 1;
  bool multicastLoopback = true;
  bool readEventsEnabled = true;
  bool writeEventsEnabled = true;

  @override
  InternetAddress get address => InternetAddress.anyIPv4;

  @override
  int get port => 1;

  @override
  StreamSubscription<RawSocketEvent> listen(
    void onData(RawSocketEvent event)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  }) {
    return Stream<RawSocketEvent>.value(RawSocketEvent.read).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  Datagram receive() {
    final response = Uint8List.fromList(
      utf8.encode(Fixtures.discoveryResponseRaw),
    );
    return Datagram(response, InternetAddress.loopbackIPv4, 1234);
  }

  @override
  int send(List<int> buffer, InternetAddress address, int port) => 0;

  @override
  void close() {}

  @override
  void joinMulticast(InternetAddress group, [NetworkInterface? interface]) {}

  @override
  void leaveMulticast(InternetAddress group, [NetworkInterface? interface]) {}

  @override
  Uint8List getRawOption(RawSocketOption option) => Uint8List.fromList([1]);

  @override
  void setRawOption(RawSocketOption option) {}
}
