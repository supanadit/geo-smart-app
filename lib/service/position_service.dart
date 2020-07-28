import 'package:dio/dio.dart';
import 'package:geosmart/model/position.dart';
import 'package:geosmart/model/response.dart';
import 'package:geosmart/service/setting_service.dart';
import 'package:meta/meta.dart';

class PositionService {
  final Dio dio;
  final SettingService _settingBloc = SettingService();

  PositionService({
    @required this.dio,
  });

  Future<ResponseModel> sendPosition(String lat, String lng) async {
    var m = await _settingBloc.getSetting();
    Position position = new Position(
      id: m.id,
      type: "user",
      lat: lat,
      lng: lng,
    );
    try {
      Response response = await dio.post(
        m.host + "/point/set",
        data: position.toJson(),
      );
      return ResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw (e);
    }
  }

  Future<ResponseModel> stopTracking() async {
    var m = await _settingBloc.getSetting();
    try {
      Response response = await dio.post(
        m.host + "/point/unset",
        data: {
          "id": m.id,
          "type": "user",
        },
      );
      return ResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw (e);
    }
  }
}
