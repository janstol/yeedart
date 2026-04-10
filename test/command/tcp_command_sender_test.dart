import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/tcp_command_sender.dart';
import 'package:yeedart/src/exception/exception.dart';
import 'package:yeedart/src/response/command_response.dart';

int parseCommandId(List<int> data) {
  final raw = utf8.decode(data).trim();
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return json['id'] as int;
}

void main() {
  late ServerSocket server;
  late int port;
  late void Function(Socket socket) socketHandler;

  setUp(() async {
    socketHandler = (Socket socket) {
      socket.listen((List<int> data) {
        final id = parseCommandId(data);
        socket.write('{"id":$id,"result":["ok"]}\r\n');
      });
    };

    server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    port = server.port;
    server.listen(socketHandler);
  });

  tearDown(() async {
    await server.close();
  });

  test('should send command successfully and then disconnect', () async {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: port,
    );

    expect(sender.isConnected, false);

    final response = await sender.sendCommand(Command.toggle(id: 1));

    expect(sender.isConnected, true);
    expect(response, CommandResponse(id: 1, result: <String>['ok']));

    sender.close();
    expect(sender.isConnected, false);
  });

  test('should emit responses to stream', () async {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: port,
    );

    final success = Uint8List.fromList(
      utf8.encode(CommandResponse(id: 1, result: <String>['ok']).raw),
    );

    await sender.sendCommand(Command.toggle(id: 1));

    expect(sender.isConnected, true);
    expectLater(
      sender.connectionStream,
      emitsInOrder(<Uint8List>[success, success]),
    );
    await sender.sendCommand(Command.toggle(id: 1));
    await sender.sendCommand(Command.toggle(id: 1));

    expect(sender.isConnected, true);
    sender.close();
  });

  test('should parse a response split across multiple socket chunks', () async {
    socketHandler = (Socket socket) {
      socket.listen((List<int> data) async {
        socket.add(utf8.encode('{"id":1,'));
        await socket.flush();
        socket.add(utf8.encode('"result":["ok"]}\r\n'));
        await socket.flush();
      });
    };

    await server.close();
    server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    port = server.port;
    server.listen(socketHandler);

    final sender = TCPCommandSender(
      address: InternetAddress.loopbackIPv4,
      port: port,
    );

    expect(
      await sender.sendCommand(Command.toggle(id: 1)),
      CommandResponse(id: 1, result: <String>['ok']),
    );
  });

  test('should ignore empty lines and notifications before command response',
      () async {
    socketHandler = (Socket socket) {
      socket.listen((List<int> data) async {
        socket.write('\r\n');
        socket.write('{"method":"props","params":{"bright":"100"}}\r\n');
        socket.write('{"id":1,"result":["ok"]}\r\n');
        await socket.flush();
      });
    };

    await server.close();
    server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    port = server.port;
    server.listen(socketHandler);

    final sender = TCPCommandSender(
      address: InternetAddress.loopbackIPv4,
      port: port,
    );

    final streamExpectation = expectLater(
      sender.connectionStream,
      emitsInOrder(<dynamic>[
        Uint8List.fromList(
          utf8.encode('{"method":"props","params":{"bright":"100"}}'),
        ),
        Uint8List.fromList(utf8.encode('{"id":1,"result":["ok"]}')),
      ]),
    );

    expect(
      await sender.sendCommand(Command.toggle(id: 1)),
      CommandResponse(id: 1, result: <String>['ok']),
    );
    await streamExpectation;
  });

  test('should throw connection exception - connection refused', () async {
    await server.close();

    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: port,
    );

    expect(
      sender.sendCommand(Command.toggle()),
      throwsException,
    );
  });

  test('should reconnect when the device closes a stale socket', () async {
    var connectionCount = 0;
    socketHandler = (Socket socket) {
      connectionCount++;
      var responded = false;
      socket.listen((List<int> data) async {
        if (responded) {
          return;
        }
        responded = true;
        final id = parseCommandId(data);
        socket.write('{"id":$id,"result":["ok"]}\r\n');
        await socket.flush();
        await socket.close();
      });
    };

    await server.close();
    server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    port = server.port;
    server.listen(socketHandler);

    final sender = TCPCommandSender(
      address: InternetAddress.loopbackIPv4,
      port: port,
    );

    expect(
      await sender.sendCommand(Command.toggle(id: 1)),
      CommandResponse(id: 1, result: <String>['ok']),
    );
    expect(
      await sender.sendCommand(Command.toggle(id: 1)),
      CommandResponse(id: 1, result: <String>['ok']),
    );
    expect(connectionCount, 2);
  });

  test('should retry once when the first connection closes before responding',
      () async {
    var connectionCount = 0;
    socketHandler = (Socket socket) {
      connectionCount++;
      socket.listen((List<int> data) async {
        if (connectionCount == 1) {
          await socket.close();
          return;
        }

        final id = parseCommandId(data);
        socket.write('{"id":$id,"result":["ok"]}\r\n');
        await socket.flush();
      });
    };

    await server.close();
    server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    port = server.port;
    server.listen(socketHandler);

    final sender = TCPCommandSender(
      address: InternetAddress.loopbackIPv4,
      port: port,
    );

    expect(
      await sender.sendCommand(Command.toggle(id: 1)),
      CommandResponse(id: 1, result: <String>['ok']),
    );
    expect(connectionCount, 2);
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

  test('should connect and disconnect', () async {
    final sender = TCPCommandSender(
      address: InternetAddress('127.0.0.1'),
      port: port,
    );

    expect(sender.isConnected, false);
    await sender.connect();
    expect(sender.isConnected, true);
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
