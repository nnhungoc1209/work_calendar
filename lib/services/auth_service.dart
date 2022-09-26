import 'package:dio/dio.dart';
import 'package:work_calendar/models/api_models/auth/change_password_model.dart';
import 'package:work_calendar/models/api_models/auth/login_model.dart';

import 'api_status.dart';

class AuthService {
  Future<Object> login(String username, String password) async {
    var loginModel = LoginModel();

    var params = {
      'username': username,
      'password': password
    };

    try {
      Dio dio = Dio();
      var response = await dio.post('http://192.168.1.14:8000/api/login', data: params);
      print(response.toString());

      if(response.data != null && response.statusCode == 201) {
        loginModel = LoginModel.fromJson(response.data);
      }

      return Success(
          code: response.statusCode,
          response: loginModel
      );
    }
    on DioError catch (e) {
      return Failure(
          code: e.response?.statusCode,
          errorResponse: e.toString()
      );
    }
  }

  Future<Object> changePassword(String username, String currentPassword, String newPassword) async {
    var changePasswordModel = ChangePasswordModel();

    var params = {
      'username': username,
      'oldPassword': currentPassword,
      'newPassword': newPassword
    };

    try {
      Dio dio = Dio();
      var response = await dio.post('http://192.168.1.14:8000/api/change-password', data: params);
      print(response.toString());

      if(response.data != null && response.statusCode == 200) {
        changePasswordModel = ChangePasswordModel.fromJson(response.data);
      }

      return Success(
          code: response.statusCode,
          response: changePasswordModel
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