import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import '../fixtures/fixtures.dart';

class MockRawDatagramSocket implements RawDatagramSocket {
  final Stream<RawSocketEvent> _events;
  final Datagram? datagram;
  final SocketException? sendException;

  MockRawDatagramSocket({
    Stream<RawSocketEvent>? events,
    this.datagram,
    this.sendException,
  }) : _events = events ?? Stream<RawSocketEvent>.value(RawSocketEvent.read);

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
    return _events.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  Stream<RawSocketEvent> timeout(
    Duration timeLimit, {
    void Function(EventSink<RawSocketEvent> sink)? onTimeout,
  }) {
    return _events.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Datagram receive() {
    return datagram ??
        Datagram(
          Uint8List.fromList(utf8.encode(Fixtures.discoveryResponseRaw)),
          InternetAddress.loopbackIPv4,
          1234,
        );
  }

  @override
  int send(List<int> buffer, InternetAddress address, int port) {
    if (sendException != null) {
      throw sendException!;
    }
    return 0;
  }

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

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
