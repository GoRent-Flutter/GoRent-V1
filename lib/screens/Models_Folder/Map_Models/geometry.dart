import 'package:gorent_application1/screens/Models_Folder/Map_Models/location.dart';

class Geometry {
  final Location location;
  Geometry({required this.location});

  factory Geometry.fromJson(Map<dynamic, dynamic> jsonList) {
    return Geometry(location: Location.fromJson(jsonList['location']));
  }
}
