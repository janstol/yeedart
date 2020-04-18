import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import '../fixtures/fixtures.dart';

class MockRawDatagramSocket extends RawDatagramSocket {
  @override
  InternetAddress get address => null;

  @override
  int get port => null;

  @override
  StreamSubscription<RawSocketEvent> listen(
    void Function(RawSocketEvent event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
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
  Uint8List getRawOption(RawSocketOption option) => null;

  @override
  void joinMulticast(InternetAddress group, [NetworkInterface interface]) {}

  @override
  void leaveMulticast(InternetAddress group, [NetworkInterface interface]) {}

  @override
  void setRawOption(RawSocketOption option) {}
}
