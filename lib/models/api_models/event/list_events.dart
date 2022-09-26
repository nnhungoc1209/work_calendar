import 'package:work_calendar/models/api_models/event/list_departments.dart';
import 'package:work_calendar/models/api_models/event/list_employees.dart';

class ListEvents {
  int? scheduleId;
  String? title;
  DateTime? startAt;
  DateTime? endAt;
  String? content;
  String? guest;
  String? note;
  bool? isGeneral;
  int? venueId;
  String? venueName;
  List<ListDepartments>? listDepartments;
  List<ListEmployees>? listEmployees;

  ListEvents(
      {this.scheduleId,
        this.title,
        this.startAt,
        this.endAt,
        this.content,
        this.guest,
        this.note,
        this.isGeneral,
        this.venueId,
        this.venueName,
        this.listDepartments,
        this.listEmployees,});

  ListEvents.fromJson(Map<String, dynamic> json) {
    scheduleId = json['schedule_id'];
    title = json['title'];
    startAt = DateTime.tryParse(json['start_at']);
    endAt = DateTime.tryParse(json['end_at']);
    content = json['content'];
    guest = json['guest'];
    note = json['note'];
    isGeneral = json['is_general'] == 1 ? true : false;
    venueId = json['venue_id'];
    venueName = json['venue_name'];
    if (json['department'] != null) {
      listDepartments = <ListDepartments>[];
      json['department'].forEach((v) {
        listDepartments!.add(ListDepartments.fromJson(v));
      });
    }
    if (json['employee'] != null) {
      listEmployees = <ListEmployees>[];
      json['employee'].forEach((v) {
        listEmployees!.add(ListEmployees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['schedule_id'] = scheduleId;
    data['title'] = title;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['content'] = content;
    data['guest'] = guest;
    data['note'] = note;
    data['is_general'] = isGeneral;
    data['venue_id'] = venueId;
    data['venue_name'] = venueName;
    if (listDepartments != null) {
      data['department'] =
          listDepartments!.map((v) => v.toJson()).toList();
    }
    if (listEmployees != null) {
      data['employee'] =
          listEmployees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
