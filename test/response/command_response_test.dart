import 'package:test/test.dart';
import 'package:yeedart/src/response/command_response.dart';

import '../fixtures/fixtures.dart';

void main() {
  final json = Fixtures.getJson('{"id": 1, "result": ["on", "", "100"]}');

  test('should parse command response', () {
    expect(
      CommandResponse.fromJson(json),
      CommandResponse(id: 1, result: <String>['on', '', '100'], error: null),
    );
  });

  test('should parse command error response', () {
    final json = Fixtures.getJson(
      '{"id": 999, "error":{"code":-1, "message":"unsupported method"}}',
    );

    final error = <String, dynamic>{
      'error': {
        'code': -1,
        'message': 'unsupported method',
      },
    };

    expect(
      CommandResponse.fromJson(json),
      CommandResponse(id: 999, error: error),
    );
  });

  test('toString returns correct value', () {
    final command = CommandResponse.fromJson(json);
    expect(command.toString(), 'CommandResponse: ${command.raw}');
  });
}
