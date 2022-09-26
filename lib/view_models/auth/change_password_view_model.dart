import 'package:flutter/material.dart';
import 'package:work_calendar/models/api_models/auth/change_password_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/auth_service.dart';

class ChangePasswordViewModel extends ChangeNotifier {

  ChangePasswordModel changePasswordModel = ChangePasswordModel();
  String? error;

  changePassword(String username, String currentPassword, String newPassword) async {
    var result = await AuthService().changePassword(username, currentPassword, newPassword);

    if (result is Failure) {
      changePasswordModel = ChangePasswordModel();
    }

    if (result is Success) {
      changePasswordModel = result.response as ChangePasswordModel;
      error = '';
    }
    notifyListeners();
  }
}