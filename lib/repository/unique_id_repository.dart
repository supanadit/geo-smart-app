import 'package:geo_app/model/setting.dart';
import 'package:geo_app/provider/unique_id_provider.dart';
import 'package:geo_app/model/unique_id_model.dart';

class UniqueIDRepository {
  UniqueIDProvider _uniqueIDProvider;
  SettingModel _settingModel;

  UniqueIDRepository(this._settingModel) {
    this._uniqueIDProvider = UniqueIDProvider(this._settingModel);
  }

  Future<UniqueIDModel> getUniqueID() {
    return this._uniqueIDProvider.getUniqueID();
  }
}
