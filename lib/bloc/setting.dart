import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geo_app/model/setting.dart';

class SettingBloc {
  PublishSubject<SettingModel> _subject;

  final String _host = "host";
  final String _id = "id";

  SettingBloc() {
    this._subject = PublishSubject<SettingModel>();
  }

  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  setSetting(SettingModel setting) async {
    SharedPreferences sharedPreferences = await this.getSharedPreferences();
    sharedPreferences.setString(_host, setting.host);
    sharedPreferences.setString(_id, setting.id);
    this.getSetting();
  }

  getSetting() async {
    SharedPreferences sharedPreferences = await this.getSharedPreferences();
    _subject.sink.add(new SettingModel(
      sharedPreferences.getString(_host),
      sharedPreferences.getString(_id),
    ));
  }

  dispose() {
    _subject.close();
  }

  PublishSubject<SettingModel> get subject => _subject;
}
