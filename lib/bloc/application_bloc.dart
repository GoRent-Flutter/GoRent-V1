import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Map/places_services.dart';
import '../screens/Map/places_search.dart';
import '../screens/Models_Folder/Map_Models/place.dart';

class ApplicationBloc with ChangeNotifier {
  late List<PlaceSearch> searchResults = [];
  final placesService = PlacesServices();
  StreamController<Place> selectedLocation = StreamController<Place>();

  ApplicationBloc() {
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    print(searchResults);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    selectedLocation.add(await placesService.getPlace(placeId));
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }

  void clearSearchResults() {
    searchResults=[];

  }

}
