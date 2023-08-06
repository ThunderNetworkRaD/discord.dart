import 'classes/message/message.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final headerswh = {
  "Content-Type": "application/json"
};

Future<http.Response> sendWH(Map content, String token, String id) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token");
  return http.post(url, body: json.encode(content), headers: headerswh);
}

Future<http.Response> editWH(Map content, String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.patch(url, body: json.encode(content), headers: headerswh);
}

Future<http.Response> getWH(String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.get(url);
}

Future<http.Response> deleteWH(String token, String id, String mid) {
  final url = Uri.parse("$apiURL/webhooks/$id/$token/messages/$mid");
  return http.delete(url);
}

Future<String> requestWebSocketURL() async {
  final url = Uri.parse("$apiURL/gateway");
  dynamic res = await http.get(url);
  res = json.decode(res.body);
  return res["url"];
}

class Sender {
  final String? _token;
  Map<String, String> headers = {};

  Sender(this._token) {
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bot $_token",
    };
  }

  Future getServers() async {
    final url = Uri.parse("$apiURL/users/@me/guilds");
    dynamic res = await http.get(url, headers: headers);
    res = json.decode(res.body);
    return res;
  }

  Future send(Message msg, String cid) async {
    final url = Uri.parse("$apiURL/channels/$cid/messages");
    dynamic res = await http.post(url, headers: headers, body: json.encode(msg.exportable()));
    res = json.decode(res.body);
    return res;
  }

  Future fetchGuild(String id) async {
    dynamic res = await http.get(Uri.parse("$apiURL/guilds/$id"), headers: headers);
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the guild");
    }
    res = json.decode(res.body);
    return res;
  }

  Future fetchChannel(String id) async {
    dynamic res = await http.get(Uri.parse("$apiURL/channels/$id"), headers: headers);
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the channel");
    }
    res = json.decode(res.body);
    return res;
  }

  Future fetchMember(String gid, String id) async {
    dynamic res = await http.get(Uri.parse("$apiURL/guilds/$gid/members/$id"), headers: headers);
    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} receiving the member");
    }
    res = json.decode(res.body);
    return res;
  }
}