import 'package:work_calendar/models/api_models/event/list_events.dart';

class GetAllEventsModel {
  List<ListEvents>? listEvents;

  GetAllEventsModel({this.listEvents});

  GetAllEventsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      listEvents = <ListEvents>[];
      json['data'].forEach((v) {
        listEvents!.add(ListEvents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (listEvents != null) {
      data['data'] = listEvents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}