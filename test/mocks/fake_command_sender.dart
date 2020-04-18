import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/command_sender.dart';
import 'package:yeedart/src/response/command_response.dart';
import 'package:yeedart/src/response/notification_message.dart';

class FakeCommandSender implements CommandSender {
  StreamController<Uint8List> _controller;
  Stream<Uint8List> _stream = const Stream.empty();
  bool _connected = false;

  @override
  bool get isConnected => _connected;

  @override
  Stream<Uint8List> get connectionStream => _stream.asBroadcastStream();

  @override
  Future<CommandResponse> sendCommand(Command command) async {
    String responseRaw;

    if (!_connected) {
      await connect();
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
          if (command.method == CommandMethods.setBright) {
            final msg = NotificationMessage(params: <String, dynamic>{
              'bright': '${command.parameters.first}'
            });
            _controller.sink.add(Uint8List.fromList(utf8.encode(msg.raw)));
          }
          responseRaw = '{"id":${command.id}, "result":["ok"]}';
      }
    } else {
      _controller.sink.add(Uint8List.fromList(utf8.encode('unsupported')));
      responseRaw = '{"id":${command.id}, "error":{"code":-1, '
          '"message":"unsupported method"}}';
    }

    final jsonMap = json.decode(responseRaw) as Map<String, dynamic>;
    return CommandResponse.fromJson(jsonMap);
  }

  /// Creates TCP connection to [address] and [port].
  Future<void> connect() async {
    _controller = StreamController.broadcast();
    _stream = _controller.stream.asBroadcastStream();
    _connected = true;
  }

  @override
  void close() {
    _controller.close();
    _connected = false;
  }
}
