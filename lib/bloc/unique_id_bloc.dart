import 'package:geo_app/model/setting.dart';
import 'package:geo_app/model/unique_id_model.dart';
import 'package:geo_app/repository/unique_id_repository.dart';
import 'package:rxdart/rxdart.dart';

class UniqueIDBloc {
  UniqueIDRepository _repository;
  final PublishSubject<UniqueIDModel> _subject =
      PublishSubject<UniqueIDModel>();

  SettingModel _settingModel;

  UniqueIDBloc(this._settingModel) {
    this._repository = UniqueIDRepository(this._settingModel);
  }

  dispose() {
    _subject.close();
  }

  getUniqueID() async {
    UniqueIDModel response = await _repository.getUniqueID();
    _subject.sink.add(response);
  }

  PublishSubject<UniqueIDModel> get subject => _subject;
}
