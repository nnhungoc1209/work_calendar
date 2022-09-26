import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:work_calendar/models/api_models/employee/get_all_employees_model.dart';
import 'package:work_calendar/services/api_status.dart';

class EmployeeService {
  Future<Object> getAllEmployees() async {
    var getAllEmployeesModel = GetAllEmployeesModel();
    try {
      Dio dio = Dio();
      var response = await dio.get('http://192.168.1.14:8000/api/employees/review');
      // print(response.toString());

      if(response.data != null && response.statusCode == 200) {
        getAllEmployeesModel = GetAllEmployeesModel.fromJson(response.data);
      }

      return Success(
          code: response.statusCode,
          response: getAllEmployeesModel
      );
    }
    on DioError catch (e) {
      return Failure(
          code: e.response?.statusCode,
          errorResponse: e.toString()
      );
    }
  }
}