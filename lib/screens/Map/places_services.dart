import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Map/places_search.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../constraints.dart';
import '../Models_Folder/Map_Models/place.dart';

class PlacesServices {
  final key = placesApi_Key;
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&type=address&components=country:il&key=$key';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?key=$key&place_id=$placeId';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
