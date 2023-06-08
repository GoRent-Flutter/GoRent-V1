import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String userId;
  final List<String> images;
  final String city;
  final String type;
  final String description;
  final int price;
  final int numRooms;
  final int numBathrooms;
  final int size;

  Favorite({
    required this.id,
    required this.userId,
    required this.images,
    required this.city,
    required this.type,
    required this.description,
    required this.price,
    required this.numRooms,
    required this.numBathrooms,
    required this.size,
  });

  static Favorite fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Favorite(
      id: doc.id,
      userId: data['userId'],
      images: List<String>.from(data['images']),
      city: data['city'],
      type: data['type'],
      description: data['description'],
      price: data['price'],
      numRooms: data['numRooms'],
      numBathrooms: data['numBathrooms'],
      size: data['size'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'images': images,
      'city': city,
      'type': type,
      'description': description,
      'price': price,
      'numRooms': numRooms,
      'numBathrooms': numBathrooms,
      'size': size,
    };
  }

  Favorite copyWith({
    String? id,
    String? userId,
    List<String>? images,
    String? city,
    String? type,
    String? description,
    int? price,
    int? numRooms,
    int? numBathrooms,
    int? size,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      images: images ?? this.images,
      city: city ?? this.city,
      type: type ?? this.type,
      description: description ?? this.description,
      price: price ?? this.price,
      numRooms: numRooms ?? this.numRooms,
      numBathrooms: numBathrooms ?? this.numBathrooms,
      size: size ?? this.size,
    );
  }
}
