import 'package:work_calendar/models/api_models/venue/list_venues.dart';

class GetAllVenuesModel {
  List<ListVenues>? listVenues;

  GetAllVenuesModel({this.listVenues});

  GetAllVenuesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      listVenues = <ListVenues>[];
      json['data'].forEach((v) {
        listVenues!.add(ListVenues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (listVenues != null) {
      data['data'] = listVenues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}