//this class is for places that will appear in search
class PlaceSearch {
  late String description;
  late String placeId;

  PlaceSearch.fromJson(Map<String, dynamic> json) {
        description= json['description'];
        placeId= json['place_id'];
  }
}
