import 'package:flutter/material.dart';
import 'package:work_calendar/models/api_models/event/delete_event_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/event_service.dart';

class DeleteEventViewModel extends ChangeNotifier {

  DeleteEventModel deleteEventsModel = DeleteEventModel();

  deleteEvent(int id) async {
    var result = await EventService().deleteEvent(id);

    if (result is Failure) {
      deleteEventsModel = DeleteEventModel();
    }

    if (result is Success) {
      deleteEventsModel = result.response as DeleteEventModel;
    }

    notifyListeners();
  }
}