import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:work_calendar/models/api_models/event/edit_event_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/event_service.dart';

class EditEventViewModel extends ChangeNotifier {

  EditEventModel addNewEventModel = EditEventModel();

  String? error;

  editEvent(int? id, String title, String guest, String note, bool isGeneral, String startAt, String endAt,
      List<dynamic> employeeList, List<dynamic> departmentList, FilePickerResult? contentFile, int venueId) async {

    var result = await EventService().editEvent(id, title, guest, note, isGeneral, startAt, endAt, employeeList, departmentList, contentFile, venueId);
    print(result);

    if(result is Failure) {
      addNewEventModel = EditEventModel();
    }

    if(result is Success) {
      addNewEventModel = result.response as EditEventModel;
      error = '';
    }

    notifyListeners();
  }
}