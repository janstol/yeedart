import 'package:yeedart/src/domain/entity/yee_command.dart';
import 'package:yeedart/src/domain/entity/yee_command_response.dart';

/// Interface that describes command sender.
///
/// To create custom command sender, implement this class.
/// Default implementation is [TCPCommandSender].
abstract class YeeCommandSender {
  /// Sends command to the device.
  Future<YeeCommandResponse> sendCommand(YeeCommand command);

  /// Closes connection to the device.
  void close();
}
