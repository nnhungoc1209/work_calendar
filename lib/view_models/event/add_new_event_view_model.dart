import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:work_calendar/models/api_models/event/add_new_event_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/event_service.dart';

class AddNewEventViewModel extends ChangeNotifier {

  AddNewEventModel addNewEventModel = AddNewEventModel();

  String? error;

  addNewEvent(String title, String guest, String note, bool isGeneral, String startAt, String endAt,
      List<dynamic> employeeList, List<dynamic> departmentList, FilePickerResult? contentFile, int venueId) async {

    var result = await EventService().addNewEvent(title, guest, note, isGeneral, startAt, endAt, employeeList, departmentList, contentFile, venueId);
    print(result);

    if(result is Failure) {
      addNewEventModel = AddNewEventModel();
    }

    if(result is Success) {
      addNewEventModel = result.response as AddNewEventModel;
      error = '';
    }

    notifyListeners();
  }
}