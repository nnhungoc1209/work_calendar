class ListVenues {
  int? venueId;
  String? name;

  ListVenues({this.venueId, this.name});

  ListVenues.fromJson(Map<String, dynamic> json) {
    venueId = json['venue_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['venue_id'] = venueId;
    data['name'] = name;
    return data;
  }
}