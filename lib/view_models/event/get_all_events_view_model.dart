import 'package:flutter/foundation.dart';
import 'package:work_calendar/models/api_models/event/get_all_events_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/event_service.dart';

class GetAllEventsViewModel extends ChangeNotifier {

  GetAllEventsModel getAllEventsModel = GetAllEventsModel();

  getAllEvents() async {
    var result = await EventService().getAllEvents();

    if (result is Failure) {
      getAllEventsModel = GetAllEventsModel();
    }

    if (result is Success) {
      getAllEventsModel = result.response as GetAllEventsModel;
    }

    notifyListeners();
  }
}