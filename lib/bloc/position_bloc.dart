import 'package:geo_app/model/response.dart';
import 'package:geo_app/model/setting.dart';
import 'package:geo_app/repository/position_repository.dart';
import 'package:rxdart/rxdart.dart';

class PositionBloc {
  PositionRepository _repository;
  final PublishSubject<ResponseModel> _subject =
      PublishSubject<ResponseModel>();

  SettingModel _settingModel;

  PositionBloc(this._settingModel) {
    this._repository = PositionRepository(this._settingModel);
  }

  dispose() {
    _subject.close();
  }

  sendPosition(String lat, String lng) async {
    ResponseModel response = await _repository.sendPosition(lat, lng);
    _subject.sink.add(response);
  }

  stopTracking(String lat, String lng) async {
    ResponseModel response = await _repository.stopTracking();
    _subject.sink.add(response);
  }

  PublishSubject<ResponseModel> get subject => _subject;
}
