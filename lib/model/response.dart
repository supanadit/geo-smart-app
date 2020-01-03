class ResponseModel {
  final String errorMessage = "error";

  String status;

  ResponseModel({this.status});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  ResponseModel.fromNull() {
    status = errorMessage;
  }

  isError() {
    return (status == errorMessage);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}
