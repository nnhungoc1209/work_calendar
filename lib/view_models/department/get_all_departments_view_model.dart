import 'package:flutter/foundation.dart';
import 'package:work_calendar/models/api_models/department/get_all_departments_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/department_service.dart';

class GetAllDepartmentsViewModel extends ChangeNotifier {

  GetAllDepartmentsModel getAllDepartmentsModel = GetAllDepartmentsModel();

  getAllDepartments() async {
    var result = await DepartmentService().getAllDepartments();

    if (result is Failure) {
      getAllDepartmentsModel = GetAllDepartmentsModel();
    }

    if (result is Success) {
      getAllDepartmentsModel = result.response as GetAllDepartmentsModel;
    }

    notifyListeners();
  }
}