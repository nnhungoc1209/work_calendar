import 'package:work_calendar/models/api_models/event/list_departments.dart';

class GetAllDepartmentsModel {
  List<ListDepartments>? listDepartments;

  GetAllDepartmentsModel({this.listDepartments});

  GetAllDepartmentsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      listDepartments = <ListDepartments>[];
      json['data'].forEach((v) {
        listDepartments!.add(ListDepartments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (listDepartments != null) {
      data['data'] = listDepartments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}