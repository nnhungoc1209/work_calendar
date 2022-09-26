import 'package:work_calendar/models/api_models/event/list_employees.dart';

class GetAllEmployeesModel {
  List<ListEmployees>? listEmployees;

  GetAllEmployeesModel({this.listEmployees});

  GetAllEmployeesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      listEmployees = <ListEmployees>[];
      json['data'].forEach((v) {
        listEmployees!.add(ListEmployees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (listEmployees != null) {
      data['data'] = listEmployees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}