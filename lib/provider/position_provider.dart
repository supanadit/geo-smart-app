import 'package:dio/dio.dart';
import 'package:geo_app/model/position.dart';
import 'package:geo_app/model/response.dart';
import 'package:geo_app/model/setting.dart';

class PositionProvider {
  final Dio _dio = Dio();
  SettingModel _settingModel;

  PositionProvider(this._settingModel);

  Future<ResponseModel> sendPosition(String lat, String lng) async {
    Position position = new Position(
      id: this._settingModel.id,
      type: "user",
      lat: lat,
      lng: lng,
    );
    try {
      Response response = await _dio.post(
        this._settingModel.host + "/point/set",
        data: position.toJson(),
      );
      return ResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      return ResponseModel.fromJson(e.response.data);
    }
  }

  Future<ResponseModel> stopTracking() async {
    try {
      Response response = await _dio.post(
        this._settingModel.host + "/point/unset",
        data: {
          "id": this._settingModel.id,
          "type": "user",
        },
      );
      return ResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      return ResponseModel.fromJson(e.response.data);
    }
  }
}
