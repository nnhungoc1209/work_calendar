class GetMessageModel {
  String? message;
  String? message2;

  GetMessageModel({this.message, this.message2});

  GetMessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    message2 = json['message2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['message2'] = message2;
    return data;
  }
}