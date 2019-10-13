import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yeedart/src/domain/entity/yee_command.dart';
import 'package:yeedart/src/domain/entity/yee_command_response.dart';
import 'package:yeedart/src/domain/exception.dart';
import 'package:yeedart/src/domain/command_sender.dart';

/// Implementation of [YeeCommandSender]
class TCPCommandSender implements YeeCommandSender {
  final InternetAddress address;
  final int port;

  @visibleForTesting
  Socket socket;

  bool connected = false;

  TCPCommandSender({@required this.address, @required this.port});

  @override
  Future<YeeCommandResponse> sendCommand(YeeCommand command) async {
    YeeCommandResponse response;

    if (!connected) {
      await _connect();
    }
    //print(command);

    socket.add(utf8.encode(command.message));

    await for (final data in socket) {
      final jsonMap = json.decode(utf8.decode(data)) as Map<String, dynamic>;
      //print(jsonMap);
      response = YeeCommandResponse.fromJson(jsonMap);
      break;
    }

    return response;
  }

  /// Creates TCP connection to [address] and [port].
  Future<void> _connect() async {
    try {
      socket = await Socket.connect(address, port);
      connected = true;
      //print("Connected to ${address.address}:$port");
    } on SocketException catch (e) {
      String additionalInfo;
      if (e.osError.errorCode == 1225) {
        additionalInfo = " Make sure that LAN control is enabled.";
      }
      throw YeeConnectionException("${e.osError.message}$additionalInfo");
    } on Exception catch (e) {
      throw YeeConnectionException(e.toString());
    }
  }

  /// Disconnects TCP connection.
  @override
  void close() {
    socket.destroy();
    connected = false;
  }
}
