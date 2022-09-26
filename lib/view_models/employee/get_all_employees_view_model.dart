import 'package:flutter/foundation.dart';
import 'package:work_calendar/models/api_models/employee/get_all_employees_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/employee_service.dart';

class GetAllEmployeesViewModel extends ChangeNotifier {

  GetAllEmployeesModel getAllEmployeesModel = GetAllEmployeesModel();

  getAllEmployees() async {
    var result = await EmployeeService().getAllEmployees();

    if (result is Failure) {
      getAllEmployeesModel = GetAllEmployeesModel();
    }

    if (result is Success) {
      getAllEmployeesModel = result.response as GetAllEmployeesModel;
    }

    notifyListeners();
  }
}