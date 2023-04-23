class Location {
  final double lat;
  final double long;

  Location({required this.lat, required this.long});

  factory Location.fromJson(Map<dynamic, dynamic> jsonList) {
    return Location(lat: jsonList['lat'], long: jsonList['lng']);
  }
}
