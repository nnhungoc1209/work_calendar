class TestAPIModel {
  String? username;
  String? password;

  TestAPIModel({this.username, this.password});

  TestAPIModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}