import 'package:flutter/material.dart';
import 'package:work_calendar/models/api_models/auth/login_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {

  LoginModel loginModel = LoginModel();
  String? error;

  login(String username, String password) async {
    var result = await AuthService().login(username, password);

    if (result is Failure) {
      loginModel = LoginModel();
    }

    if (result is Success) {
      loginModel = result.response as LoginModel;
      error = '';
    }

    notifyListeners();
  }
}