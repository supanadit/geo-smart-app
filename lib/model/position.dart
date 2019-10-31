import 'dart:convert';

import 'package:geo_app/config.dart';
import 'package:geo_app/model/response.dart';
import 'package:geo_app/model/unique_id.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Position {
  String id;
  String type;
  String lat;
  String lng;

  Position({this.id, this.type, this.lat, this.lng});

  Position.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }

  static Future<Position> getPosition() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String keyName = "unique_id";
    String spId = (sp.getString(keyName) ?? null);
    Position position = new Position(
      id: spId,
      type: "user",
      lat: "0.0",
      lng: "0.0",
    );
    if (spId == null) {
      final response = await http.get(Config.api + "/unique/id");
      if (response.statusCode == 200) {
        position.id = UniqueId.fromJson(json.decode(response.body)).id;
      } else {
        throw Exception("Something Error");
      }
      sp.setString(keyName, position.id);
    }
    return position;
  }

  bool isValid() {
    return id != null;
  }

  Future<Response> sendPosition() async {
    Response result;
    final response = await http.post(
      Config.api + "/set/point",
      body: json.encode(this.toJson()),
    );
    if (response.statusCode == 200) {
      result = Response.fromJson(json.decode(response.body));
    } else {
      throw Exception("Something Error");
    }
    return result;
  }
}
