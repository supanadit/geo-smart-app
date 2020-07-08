import 'package:dio/dio.dart';
import 'package:geosmart/model/position.dart';
import 'package:geosmart/model/response.dart';
import 'package:geosmart/service/setting_service.dart';

class PositionService {
  final Dio _dio = Dio();
  final SettingService _settingBloc = SettingService();

  PositionService();

  Future<ResponseModel> sendPosition(String lat, String lng) async {
    var m = await _settingBloc.getSetting();
    Position position = new Position(
      id: m.id,
      type: "user",
      lat: lat,
      lng: lng,
    );
    try {
      Response response = await _dio.post(
        m.host + "/point/set",
        data: position.toJson(),
      );
      return ResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.response);
      if (e.response != null) {
        return ResponseModel.fromJson(e.response.data);
      } else {
        return ResponseModel.fromNull();
      }
    }
  }

  Future<ResponseModel> stopTracking() async {
    var m = await _settingBloc.getSetting();
    try {
      Response response = await _dio.post(
        m.host + "/point/unset",
        data: {
          "id": m.id,
          "type": "user",
        },
      );
      return ResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      return ResponseModel.fromJson(e.response.data);
    }
  }
}
