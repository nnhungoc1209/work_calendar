class ListDepartments {
  int? departmentId;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  ListDepartments(
      {this.departmentId,
        this.name,
        this.createdAt,
        this.updatedAt});

  ListDepartments.fromJson(Map<String, dynamic> json) {
    departmentId = json['department_id'];
    name = json['name'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['department_id'] = departmentId;
    data['name'] = name;
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    return data;
  }
}