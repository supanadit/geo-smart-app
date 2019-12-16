import 'package:dio/dio.dart';
import 'package:geo_app/model/setting.dart';
import 'package:geo_app/model/unique_id_model.dart';

class UniqueIDProvider {
  final String _endpoint = "/id/get/unique";
  final Dio _dio = Dio();
  SettingModel _settingModel;

  UniqueIDProvider(this._settingModel);

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
