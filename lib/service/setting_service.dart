import 'package:geosmart/model/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService {
  final String _host = "host";
  final String _id = "id";

  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<SettingModel> setSetting(SettingModel setting) async {
    SharedPreferences sharedPreferences = await this.getSharedPreferences();
    sharedPreferences.setString(_host, setting.host);
    sharedPreferences.setString(_id, setting.id);
    return await getSetting();
  }

  Future<SettingModel> getSetting() async {
    SharedPreferences sharedPreferences = await this.getSharedPreferences();
    return new SettingModel(
      sharedPreferences.getString(_host),
      sharedPreferences.getString(_id),
    );
  }
}
