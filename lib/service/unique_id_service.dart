import 'package:dio/dio.dart';
import 'package:geosmart/model/setting.dart';
import 'package:geosmart/model/unique_id_model.dart';

class UniqueIDService {
  final String _endpoint = "/id/get/unique";
  final Dio _dio = Dio();
  SettingModel _settingModel;

  UniqueIDService(this._settingModel);

  Future<UniqueIDModel> getUniqueID() async {
    try {
      Response response = await _dio.get(
        this._settingModel.host + _endpoint,
      );
      return UniqueIDModel.fromJson(response.data);
    } on DioError catch (e) {
      return UniqueIDModel.error();
    }
  }
}
