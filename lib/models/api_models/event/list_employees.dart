class ListEmployees {
  int? employeeId;
  String? username;
  String? password;
  String? fullname;
  String? phoneNumber;
  int? roleId;
  int? departmentId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ListEmployees(
      {this.employeeId,
        this.username,
        this.password,
        this.fullname,
        this.phoneNumber,
        this.roleId,
        this.departmentId,
        this.createdAt,
        this.updatedAt});

  ListEmployees.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    username = json['username'];
    password = json['password'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    roleId = json['role_id'];
    departmentId = json['department_id'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['role_id'] = this.roleId;
    data['department_id'] = this.departmentId;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    return data;
  }
}