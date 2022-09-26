import 'package:dio/dio.dart';
import 'package:work_calendar/models/api_models/venue/get_all_venues_model.dart';
import 'package:work_calendar/services/api_status.dart';

class VenueService {
  Future<Object> getAllVenues() async {
    var getAllVenuesModel = GetAllVenuesModel();
    try {
      Dio dio = Dio();
      var response = await dio.get('http://192.168.1.14:8000/api/venues/review');
      // print(response.toString());

      if(response.data != null && response.statusCode == 200) {
        getAllVenuesModel = GetAllVenuesModel.fromJson(response.data);
      }

      return Success(
          code: response.statusCode,
          response: getAllVenuesModel
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