class User {
  int? employeeId;
  String? username;
  String? fullname;
  String? phoneNumber;
  int? roleId;
  int? departmentId;
  Null? createdAt;
  String? updatedAt;

  User(
      {this.employeeId,
        this.username,
        this.fullname,
        this.phoneNumber,
        this.roleId,
        this.departmentId,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    username = json['username'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    roleId = json['role_id'];
    departmentId = json['department_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['username'] = username;
    data['fullname'] = fullname;
    data['phone_number'] = phoneNumber;
    data['role_id'] = roleId;
    data['department_id'] = departmentId;
    return data;
  }
}