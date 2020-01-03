class ResponseModel {
  String status;

  ResponseModel({this.status});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  ResponseModel.fromNull() {
    status = "Error";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}
