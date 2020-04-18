import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/tcp_command_sender.dart';
import 'package:yeedart/src/exception/exception.dart';
import 'package:yeedart/src/response/command_response.dart';

void main() {
  ServerSocket server;

  setUp(() async {
    server = await ServerSocket.bind(InternetAddress.anyIPv4, 55555);
    server.listen((Socket socket) {
      socket.listen((List<int> data) {
        socket.write('{"id":1,"result":["ok"]}');
      });
    });
  });

  tearDown(() {
    server.close();
  });

  test('should send command successfully and then disconnect', () async {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: 55555,
    );

    expect(sender.isConnected, false);

    final response = await sender.sendCommand(Command.toggle());

    expect(sender.isConnected, true);
    expect(response, CommandResponse(id: 1, result: <String>['ok']));

    sender.close();
    expect(sender.isConnected, false);
  });

  test('should emit responses to stream', () async {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: 55555,
    );

    final success = Uint8List.fromList(
      utf8.encode(CommandResponse(id: 1, result: <String>['ok']).raw),
    );

    await sender.sendCommand(Command.toggle());

    expect(sender.isConnected, true);
    expectLater(
      sender.connectionStream,
      emitsInOrder(<Uint8List>[success, success]),
    );
    await sender.sendCommand(Command.toggle());
    await sender.sendCommand(Command.toggle());

    expect(sender.isConnected, true);
    sender.close();
  });

  test('should throw connection exception - connection refused', () async {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: 123,
    );

    expect(
      sender.sendCommand(Command.toggle()),
      throwsA(predicate<YeelightConnectionException>(
          (e) => e.message.contains('Make sure that LAN control is enabled.'))),
    );
  });

  test('TCPCommandSenders equality', () {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: 1234,
    );

    expect(
      sender,
      TCPCommandSender(address: InternetAddress.loopbackIPv4, port: 1234),
    );
    expect(
      sender,
      isNot(TCPCommandSender(address: InternetAddress.loopbackIPv4, port: 999)),
    );
  });

  test('hashCode returns correct value', () {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: 1234,
    );

    expect(
      sender.hashCode,
      sender.address.hashCode ^
          sender.port.hashCode ^
          sender.socket.hashCode ^
          sender.isConnected.hashCode,
    );
  });

//  RawDatagramSocket.bind(InternetAddress.anyIPv4, 8889)
//      .then((RawDatagramSocket udpSocket) {
//    print('${udpSocket.address.address}:${udpSocket.port}');
//
//    udpSocket.broadcastEnabled = true;
//    udpSocket.listen((e) {
//      Datagram dg = udpSocket.receive();
//      if (dg != null) {
//        print('received from ${dg.address} ${utf8.decode(dg.data)}');
//      }
//    });
//    List<int> data = utf8.encode('TEST');
//    udpSocket.send(data, InternetAddress.loopbackIPv4, 8889);
//  });
}
