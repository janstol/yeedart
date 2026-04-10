import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/command/command_sender.dart';
import 'package:yeedart/src/exception/exception.dart';
import 'package:yeedart/src/response/command_response.dart';

/// Implementation of [CommandSender]
class TCPCommandSender implements CommandSender {
  final InternetAddress address;
  final int port;
  final StreamController<Uint8List> _messageController =
      StreamController<Uint8List>.broadcast();
  final Map<int, Completer<CommandResponse?>> _pendingResponses =
      <int, Completer<CommandResponse?>>{};

  @visibleForTesting
  Socket? socket;

  String _receiveBuffer = '';

  bool _connected = false;

  TCPCommandSender({required this.address, required this.port});

  @override
  bool get isConnected => _connected;

  @override
  Stream<Uint8List> get connectionStream => _messageController.stream;

  @override
  Future<CommandResponse?> sendCommand(Command command) async {
    final message = command.message;
    final commandId = command.id!;

    return _sendCommand(
      commandId: commandId,
      message: message,
      retryOnConnectionError: true,
    );
  }

  Future<CommandResponse?> _sendCommand({
    required int commandId,
    required String message,
    required bool retryOnConnectionError,
  }) async {
    if (!_connected) {
      await connect();
    }

    final completer = Completer<CommandResponse?>();
    _pendingResponses[commandId] = completer;

    try {
      socket!.add(utf8.encode(message));
      await socket!.flush();
      return await completer.future;
    } on YeelightConnectionException catch (e) {
      _pendingResponses.remove(commandId);
      if (retryOnConnectionError) {
        return _retrySendCommand(
          commandId: commandId,
          message: message,
          cause: e,
        );
      }
      rethrow;
    } on SocketException catch (e) {
      _pendingResponses.remove(commandId);
      if (retryOnConnectionError) {
        return _retrySendCommand(
          commandId: commandId,
          message: message,
          cause: e,
        );
      }
      throw YeelightConnectionException(_formatSocketException(e));
    }
  }

  /// Creates TCP connection to [address] and [port].
  /// Note: You don't have to call this method when you use `sendCommand`.
  @override
  Future<void> connect() async {
    if (_connected) return;

    try {
      socket = await Socket.connect(address, port);
      socket!.listen(
        _handleSocketData,
        onError: _handleSocketError,
        onDone: _handleSocketDone,
        cancelOnError: true,
      );
      _connected = true;
    } on SocketException catch (e) {
      _resetConnection();
      throw YeelightConnectionException(_formatSocketException(e));
    }
  }

  /// Disconnects TCP connection.
  @override
  void close() {
    _resetConnection();
  }

  void _handleSocketData(Uint8List data) {
    _receiveBuffer += utf8.decode(data);

    while (true) {
      final separatorIndex = _receiveBuffer.indexOf('\n');
      if (separatorIndex == -1) {
        return;
      }

      final message = _receiveBuffer.substring(0, separatorIndex).trim();
      _receiveBuffer = _receiveBuffer.substring(separatorIndex + 1);

      if (message.isEmpty) {
        continue;
      }

      final encodedMessage = Uint8List.fromList(utf8.encode(message));
      _messageController.add(encodedMessage);

      final jsonMap = json.decode(message) as Map<String, dynamic>;
      final responseId = jsonMap['id'] as int?;

      if (responseId != null &&
          (jsonMap.containsKey('result') || jsonMap.containsKey('error'))) {
        _pendingResponses.remove(responseId)?.complete(
              CommandResponse.fromJson(jsonMap),
            );
      }
    }
  }

  void _handleSocketError(Object error) {
    if (error is SocketException) {
      _failPendingResponses(
          YeelightConnectionException(_formatSocketException(error)));
    } else {
      _failPendingResponses(
        YeelightConnectionException(error.toString()),
      );
    }
    _resetConnection();
  }

  void _handleSocketDone() {
    _failPendingResponses(
      const YeelightConnectionException('Connection closed by remote host.'),
    );
    _resetConnection();
  }

  Future<CommandResponse?> _retrySendCommand({
    required int commandId,
    required String message,
    required Object cause,
  }) async {
    _resetConnection();
    try {
      return await _sendCommand(
        commandId: commandId,
        message: message,
        retryOnConnectionError: false,
      );
    } on SocketException catch (e) {
      throw YeelightConnectionException(_formatSocketException(e));
    } on YeelightConnectionException {
      rethrow;
    } catch (_) {
      if (cause is SocketException) {
        throw YeelightConnectionException(_formatSocketException(cause));
      }
      if (cause is YeelightConnectionException) {
        throw cause;
      }
      rethrow;
    }
  }

  void _failPendingResponses(YeelightConnectionException error) {
    final completers = _pendingResponses.values.toList();
    _pendingResponses.clear();
    for (final completer in completers) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    }
  }

  void _resetConnection() {
    socket?.destroy();
    socket = null;
    _receiveBuffer = '';
    _connected = false;
  }

  String _formatSocketException(SocketException e) {
    String? additionalInfo;
    if (e.osError?.errorCode == 1225) {
      additionalInfo = ' Make sure that LAN control is enabled.';
    }

    final message = e.osError?.message ?? e.message;
    return '$message${additionalInfo ?? ''}';
  }

  @override
  int get hashCode =>
      address.hashCode ^ port.hashCode ^ socket.hashCode ^ _connected.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TCPCommandSender &&
            runtimeType == other.runtimeType &&
            address == other.address &&
            port == other.port &&
            socket == other.socket &&
            isConnected == other.isConnected;
  }
}
