import 'package:geo_app/model/response.dart';
import 'package:geo_app/model/setting.dart';
import 'package:geo_app/provider/position_provider.dart';

class PositionRepository {
  PositionProvider _provider;
  SettingModel _settingModel;

  PositionRepository(this._settingModel) {
    this._provider = PositionProvider(this._settingModel);
  }

  Future<ResponseModel> sendPosition(String lat, String lng) {
    return this._provider.sendPosition(lat, lng);
  }

  Future<ResponseModel> stopTracking() {
    return this._provider.stopTracking();
  }
}
