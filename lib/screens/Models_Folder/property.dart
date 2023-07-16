class Property {
  final List<String> images;
  final String city;
  final String type;
  final String description;
  final int price;
  final int numRooms;
  final int numBathrooms;
  final int size;
  final int numVerandas;

  Property(
      {required this.images,
      required this.city,
      required this.type,
      required this.description,
      required this.price,
      required this.numRooms,
      required this.numBathrooms,
      required this.size,
      required this.numVerandas});
}