class UniqueIDModel {
  String id;
  bool error = false;

  UniqueIDModel({this.id});

  UniqueIDModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  UniqueIDModel.error() {
    error = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
