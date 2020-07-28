class SettingModel {
  String host = "";
  String id = "";

  SettingModel(this.host, this.id);

  bool isNullHost() {
    return (this.host == "" || this.host == null);
  }

  bool isNullId() {
    return (this.id == "" || this.id == null);
  }

  bool isValid() {
    return (!isNullHost() && !isNullId());
  }
}
