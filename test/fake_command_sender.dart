import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/command_sender.dart';
import 'package:yeedart/src/response/command_response.dart';

class FakeCommandSender implements CommandSender {
  StreamController<Uint8List> _controller;
  Stream<Uint8List> _stream = const Stream.empty();
  bool connected = false;

  @override
  Stream<Uint8List> get connectionStream => _stream;

  @override
  Future<CommandResponse> sendCommand(Command command) async {
    String responseRaw;

    if (!connected) {
      await _connect();
    }

    if (CommandMethods.methodExists(command.method)) {
      switch (command.method) {
        case CommandMethods.getProp:
          responseRaw = '{"id": ${command.id}, "result": ["on", "", "100"]}';
          break;
        case CommandMethods.cronGet:
          responseRaw = '{"id": ${command.id}, '
              '"result": [{"type": 0, "delay": 15, "mix": 0}]}';
          break;
        default:
          responseRaw = '{"id":${command.id}, "result":["ok"]}';
      }
    } else {
      responseRaw = '{"id":${command.id}, "error":{"code":-1, '
          '"message":"unsupported method"}}';
    }

    // _controller.sink.add(Uint8List.fromList(utf8.encode(responseRaw)));
    final jsonMap = json.decode(responseRaw) as Map<String, dynamic>;
    return CommandResponse.fromJson(jsonMap);
  }

  /// Creates TCP connection to [address] and [port].
  Future<void> _connect() async {
    _controller = StreamController.broadcast();
    _stream = _controller.stream.asBroadcastStream();
    connected = true;
  }

  @override
  void close() {
    _controller.close();
  }
}
