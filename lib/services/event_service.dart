import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:work_calendar/models/api_models/event/add_new_event_model.dart';
import 'package:work_calendar/models/api_models/event/delete_event_model.dart';
import 'package:work_calendar/models/api_models/event/edit_event_model.dart';
import 'package:work_calendar/models/api_models/event/get_all_events_model.dart';
import 'package:dio/dio.dart';
import 'package:work_calendar/services/api_status.dart';

class EventService {
  Future<Object> getAllEvents() async {
    var getAllEventsModel = GetAllEventsModel();
    try {
      Dio dio = Dio();
      var response = await dio.get('http://192.168.1.14:8000/api/schedules');

      if(response.data != null && response.statusCode == 200) {
        getAllEventsModel = GetAllEventsModel.fromJson(response.data);
        //print(response.toString());
      }
      
      return Success(
        code: response.statusCode,
        response: getAllEventsModel
      );
    }
    on DioError catch (e) {
      return Failure(
        code: e.response?.statusCode,
        errorResponse: e.toString()
      );
    }
  }

  Future<Object> deleteEvent(int id) async {
    var deleteEventModel = DeleteEventModel();
    try {
      Dio dio = Dio();
      var response = await dio.delete('http://192.168.1.14:8000/api/schedules/' + id.toString());

      if(response.data != null && response.statusCode == 200) {
        print('Đã xóa thành công event ' + id.toString());
        deleteEventModel = DeleteEventModel.fromJson(response.data);
      }

      return Success(
          code: response.statusCode,
          response: deleteEventModel
      );
    }
    on DioError catch (e) {
      return Failure(
          code: e.response?.statusCode,
          errorResponse: e.toString()
      );
    }
  }

  Future<Object> addNewEvent(String title, String? guest, String? note, bool isGeneral, String startAt, String endAt,
      List<dynamic>? employeeList, List<dynamic>? departmentList, FilePickerResult? contentFile, int venueId) async {
    var addNewEventModel = AddNewEventModel();
    MultipartFile? multipartFile;
    String? fileName = contentFile?.files.first.name;
    String? path = contentFile?.files.first.path;
    if(contentFile != null) {
      multipartFile = await MultipartFile.fromFile(path!, filename: fileName);
    }
    DateTime sendStartAt = DateFormat('dd-MM-yyyy HH:mm').parse(startAt);
    DateTime sendEndAt = DateFormat('dd-MM-yyyy HH:mm').parse(endAt);
    print('Service: ' + endAt.toString());
    print('Service: ' + sendEndAt.toString());
    List<dynamic> sendEmployeeList = [];
    employeeList?.forEach((element) {
      sendEmployeeList.add(element.employeeId);
    });

    List<dynamic> sendDepartmentList = [];
    departmentList?.forEach((element) {
      sendDepartmentList.add(element.departmentId);
    });

    FormData formData = FormData.fromMap({
      'title': title,
      'guest': guest,
      'note': note,
      'isGeneral': isGeneral ? 1 : 0,
      'startAt': sendStartAt,
      'endAt': sendEndAt,
      'employeeList[]': sendEmployeeList,
      'departmentList[]': sendDepartmentList,
      'file': multipartFile,
      'venue_id': venueId
    });

    try {
      Dio dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response = await dio.post('http://192.168.1.14:8000/api/schedules', data: formData);
      print(response);
      print(response.statusCode);

      if(response.data != null && response.statusCode == 200) {
        print('Đã thêm thành công event');
        addNewEventModel = AddNewEventModel.fromJson(response.data);
      }

      return Success(
          code: response.statusCode,
          response: addNewEventModel,
      );
    }
    on DioError catch (e) {
      print('Exception:' + e.response.toString());
      return Failure(
          code: e.response?.statusCode,
          errorResponse: e.toString()
      );
    }
  }

  Future<Object> editEvent(int? id, String title, String? guest, String? note, bool isGeneral, String startAt, String endAt,
      List<dynamic>? employeeList, List<dynamic>? departmentList, FilePickerResult? contentFile, int venueId) async {
    var editEventModel = EditEventModel();
    MultipartFile? multipartFile;
    String? fileName = contentFile?.files.first.name;
    String? path = contentFile?.files.first.path;
    if(contentFile != null) {
      multipartFile = await MultipartFile.fromFile(path!, filename: fileName);
    }
    DateTime sendStartAt = DateFormat('dd-MM-yyyy HH:mm').parse(startAt);
    DateTime sendEndAt = DateFormat('dd-MM-yyyy HH:mm').parse(endAt);
    print('Service: ' + endAt.toString());
    print('Service: ' + sendEndAt.toString());
    List<dynamic> sendEmployeeList = [];
    employeeList?.forEach((element) {
      sendEmployeeList.add(element.employeeId);
    });

    List<dynamic> sendDepartmentList = [];
    departmentList?.forEach((element) {
      sendDepartmentList.add(element.departmentId);
    });

    FormData formData = FormData.fromMap({
      'id': id,
      'title': title,
      'guest': guest,
      'note': note,
      'isGeneral': isGeneral ? 1 : 0,
      'startAt': sendStartAt,
      'endAt': sendEndAt,
      'employeeList[]': sendEmployeeList,
      'departmentList[]': sendDepartmentList,
      'file': multipartFile,
      'venue_id': venueId
    });

    try {
      Dio dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response = await dio.post('http://192.168.1.14:8000/api/schedules/' + id.toString() + '?_method=PUT',
          data: formData);
      print(response);
      print(response.statusCode);

      if(response.data != null && response.statusCode == 200) {
        print('Đã sửa thành công event');
        editEventModel = EditEventModel.fromJson(response.data);
      }

      return Success(
        code: response.statusCode,
        response: editEventModel,
      );
    }
    on DioError catch (e) {
      print('Exception:' + e.response.toString());
      return Failure(
          code: e.response?.statusCode,
          errorResponse: e.toString()
      );
    }
  }
}