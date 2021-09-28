import 'dart:typed_data';

import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/response/command_response.dart';

/// Interface that describes command sender.
///
/// To create custom command sender, implement this class.
/// Default implementation is [TCPCommandSender].
abstract class CommandSender {
  bool get isConnected;
  Stream<Uint8List> get connectionStream;

  /// Creates connections and sends command to the device.
  Future<CommandResponse?> sendCommand(Command command);

  /// Connects to the device manually.
  Future<void> connect();

  /// Closes connection to the device.
  void close();
}
