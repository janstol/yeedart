class Parser {
  /// Uses regex to parse discovery response.
  static Map<String, String> parseDiscoveryResponse(String response) {
    final regExp = RegExp(
      r"HTTP/1.1 200 OK\r\n"
      r"Cache-Control: max-age=(?<refresh_interval>\d+)\r\n"
      r"Date:(?<date>.*)\r\n"
      r"Ext:(?<ext>.*)\r\n"
      r"Location: yeelight://(?<address>(?=.*[^\.]$)((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.?){4})\:(?<port>\d+)\r\n"
      r"Server: (?<server>.*)\r\n"
      r"id: (?<id>.*)\r\n"
      r"model: (?<model>.*)\r\n"
      r"fw_ver: (?<fw_ver>.*)\r\n"
      r"support: (?<support>.*)\r\n"
      r"power: (?<power>.*)\r\n"
      r"bright: (?<bright>.*)\r\n"
      r"color_mode: (?<color_mode>.*)\r\n"
      r"ct: (?<ct>\d+)\r\n"
      r"rgb: (?<rgb>\d+)\r\n"
      r"hue: (?<hue>\d+)\r\n"
      r"sat: (?<sat>[0-9]|[1-8][0-9]|9[0-9]|100)\r\n"
      r"name: (?<name>.*)\r\n",
      dotAll: true,
      caseSensitive: false,
      multiLine: true,
    );

    final match = regExp.firstMatch(response);

    return <String, String>{
      "refresh_interval": match.namedGroup("refresh_interval"),
      "address": match.namedGroup("address"),
      "port": match.namedGroup("port"),
      "id": match.namedGroup("id"),
      "model": match.namedGroup("model"),
      "fw_ver": match.namedGroup("fw_ver"),
      "support": match.namedGroup("support"),
      "powered": match.namedGroup("power"),
      "bright": match.namedGroup("bright"),
      "color_mode": match.namedGroup("color_mode"),
      "ct": match.namedGroup("ct"),
      "rgb": match.namedGroup("rgb"),
      "hue": match.namedGroup("hue"),
      "sat": match.namedGroup("sat"),
      "name": match.namedGroup("name"),
      "raw": response,
    };
  }
}
