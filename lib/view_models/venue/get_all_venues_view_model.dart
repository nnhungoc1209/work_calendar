import 'package:flutter/foundation.dart';
import 'package:work_calendar/models/api_models/department/get_all_departments_model.dart';
import 'package:work_calendar/models/api_models/venue/get_all_venues_model.dart';
import 'package:work_calendar/services/api_status.dart';
import 'package:work_calendar/services/department_service.dart';
import 'package:work_calendar/services/venue_service.dart';

class GetAllVenuesViewModel extends ChangeNotifier {

  GetAllVenuesModel getAllVenuesModel = GetAllVenuesModel();

  getAllVenues() async {
    var result = await VenueService().getAllVenues();

    if (result is Failure) {
      getAllVenuesModel = GetAllVenuesModel();
    }

    if (result is Success) {
      getAllVenuesModel = result.response as GetAllVenuesModel;
    }

    notifyListeners();
  }
}