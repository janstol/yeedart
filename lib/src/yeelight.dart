import 'dart:convert';
import 'dart:io';

import 'package:yeedart/src/response/discovery_response.dart';

// ignore: avoid_classes_with_only_static_members
class Yeelight {
  static const _address = '239.255.255.250';
  static const _port = 1982;

  /// Sends search message to discover Yeelight devices.
  ///
  /// Returns list of [DiscoveryResponse] which you can use to establish a
  /// connection to device.
  ///
  /// Message should follow this format:
  /// ```
  /// M-SEARCH * HTTP/1.1
  /// HOST: 239.255.255.250:1982
  /// MAN: "ssdp:discover"
  /// ST: wifi_bulb
  /// ```
  /// * First line must be `M-SEARCH * HTTP/1.1`.
  /// * 'HOST' header is optional. If present, the value should be
  /// `239.255.255.250:1982`.
  /// * 'MAN' header is *required* and value must be `"ssdp:discover"`
  /// (with double quotes).
  /// * 'ST' header is required and value must be `wifi_bulb`.
  /// * Headers are case-insensitive, start line and all the header values are
  /// case sensitive.
  /// * Each line should be terminated by `\r\n`.
  ///
  /// Any messages that doesn't follow these rules will be silently dropped.
  static Future<List<DiscoveryResponse>> discover({
    Duration timeout = const Duration(seconds: 2),
    String address = _address,
    int port = _port,
    RawDatagramSocket? socket,
  }) async {
    final internetAddress = InternetAddress(address);
    final message = createDiscoveryMessage(internetAddress, port);

    final responses = <DiscoveryResponse>[];

    final udpSocket =
        socket ?? await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    final udpSocketEventStream = udpSocket.timeout(
      timeout,
      onTimeout: (e) => udpSocket.close(),
    );

    // send discovery message
    udpSocket.send(utf8.encode(message), internetAddress, port);

    await for (final event in udpSocketEventStream) {
      if (event == RawSocketEvent.read) {
        final datagram = udpSocket.receive();
        if (datagram != null && datagram.data.isNotEmpty) {
          //print(utf8.decode(datagram.data));
          final response =
              DiscoveryResponse.fromRawResponse(utf8.decode(datagram.data));

          if (!responses.contains(response)) {
            responses.add(response);
          }
        }
      }
    }

    return responses;
  }

  /// Message should follow this format:
  /// ```
  /// M-SEARCH * HTTP/1.1
  /// HOST: 239.255.255.250:1982
  /// MAN: "ssdp:discover"
  /// ST: wifi_bulb
  /// ```
  static String createDiscoveryMessage(
    InternetAddress internetAddress,
    int port,
  ) {
    return 'M-SEARCH * HTTP/1.1\r\n'
        'HOST: ${internetAddress.address}:$port\r\n'
        'MAN: "ssdp:discover"\r\n'
        'ST: wifi_bulb\r\n';
  }
}
