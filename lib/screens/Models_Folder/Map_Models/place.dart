import 'dart:convert';

import 'package:gorent_application1/screens/Models_Folder/Map_Models/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String nearby;

  Place({required this.geometry, required this.name, required this.nearby});
  factory Place.fromJson(Map<dynamic, dynamic> jsonList) {
    return Place(
        name: jsonList['formatted_address'],
        nearby: jsonList['vicinity'],
        geometry: Geometry.fromJson(jsonList['geometry']));
  }
}
