import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:work_calendar/models/test/test_api_model.dart';

class TestAPIViewModel extends ChangeNotifier {

  TestAPIModel testAPIModel = TestAPIModel();

  //String error = '';

  sendUserInfo(String username, String password) async {
    String usernameSend = username;
    String passwordSend = password;
    
    var params = {
      'username': usernameSend,
      'password': passwordSend
    };

    try {
      Dio dio = Dio();
      var response = await dio.post('http://192.168.1.14:8000/api/example', data: jsonEncode(params));
      print('Response: ' + response.data.toString());
      print('Status:' + response.statusCode.toString());
      print(params);
      print(jsonEncode(params));
    } catch(exception) {
      print('Exceptionn: ' + exception.toString());
    }
    notifyListeners();
  }


  getMessage() async {
    try {
      Dio  dio = Dio();
      var response = await dio.get('http://192.168.1.14:8000/api/example');
      print('Response: ' + response.data.toString());
      print('Status:' + response.statusCode.toString());
    } catch(exception) {
      print('Exceptionn: ' + exception.toString());
    }
    notifyListeners();
  }
}