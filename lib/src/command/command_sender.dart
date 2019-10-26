import 'dart:typed_data';

import 'package:yeedart/src/command/command.dart';
import 'package:yeedart/src/response/command_response.dart';

/// Interface that describes command sender.
///
/// To create custom command sender, implement this class.
/// Default implementation is [TCPCommandSender].
abstract class CommandSender {
  Stream<Uint8List> get connectionStream;

  /// Sends command to the device.
  Future<CommandResponse> sendCommand(Command command);

  /// Closes connection to the device.
  void close();
}
