import 'package:dio/dio.dart';
import 'package:geosmart/model/unique_id_model.dart';

class UniqueIDService {
  final String _endpoint = "/id/get/unique";

  Future<UniqueIDModel> getUniqueID(String host, Dio dio) async {
    try {
      Response response = await dio.get(
        host + _endpoint,
      );
      return UniqueIDModel.fromJson(response.data);
    } on DioError catch (e) {
      throw (e);
    }
  }
}
