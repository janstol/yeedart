import 'package:yeedart/yeedart.dart';

Future<void> main() async {
  // Discover devices
  final responses = await Yeelight.discover();
  if (responses.isEmpty) {
    print("Didn't find yeelight device in the network");
    return;
  }
  final response = responses.first;
  final device = Device(address: response.address, port: response.port!);
  // device.turnOn();
  // await Future<void>.delayed(const Duration(seconds: 3));
  // device.turnOff();
  // device.disconnect();

  // Connect directly to device
  // (connection is created when a command is sent, in this example `getProps`)
  // final device = Device(
  //   address: InternetAddress('192.168.1.183'),
  //   port: 55443,
  // );

  // ignore: avoid_print
  print(
    await device.getProps(
      id: 1,
      parameters: [
        'name',
        'model',
        'fw_ver',
        'power',
        'color_mode',
        'bright',
        'ct',
        'rgb',
        'hue',
        'sat',
      ],
    ),
  );

  await device.turnOn();
  await Future<void>.delayed(const Duration(seconds: 3));
  await device.turnOff();
  device.disconnect();

  // Connect manually to the device
  // (for example when you don't want to send any command and just listen
  // notification stream)
  // final device = Device(address:
  //   InternetAddress('192.168.1.183'),
  //   port: 55443
  // );
  // await device.connect();
  // print('Connected: ${device.isConnected}');

  // device.notificationMessageStream.listen((event){
  //   print(event);
  // });

  // await Future<void>.delayed(const Duration(seconds: 15));
  // device.disconnect();
}
