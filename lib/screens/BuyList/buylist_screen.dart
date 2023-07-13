import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/BuyList/card.dart';
import '../Filters/filters.dart';
import '../Main/main_screen.dart';
import '../RentList/rentlist_screen.dart';
import '../RentList/square.dart';

class Estate {
  final List<String> images;
  final String city;
  final String type;
  final String description;
  final int price;
  final int numRooms;
  final int numBathrooms;
  final int size;
  final int numVerandas;
  final String address1;
  final String OwnerID;
  final double longitude;
  final double latitude;

  Estate({
    required this.images,
    required this.city,
    required this.type,
    required this.description,
    required this.price,
    required this.numRooms,
    required this.numBathrooms,
    required this.size,
    required this.numVerandas,
    required this.address1,
    required this.OwnerID,
    required this.longitude,
    required this.latitude,
  });
}

class BuyListScreen extends StatefulWidget {
  final int currentIndex;
  BuyListScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _BuyListScreenState createState() => _BuyListScreenState();
}

class _BuyListScreenState extends State<BuyListScreen> {
  late DatabaseReference _databaseRef;
  late String searchQuery = '';
  List<Estate> _estates = [];
  List<Map<String, dynamic>> estatesAll = [];
  List<Map<String, dynamic>> postsAll = [];
  List<Post> _posts = [];

//for filters
  bool _isRentSelected = true;
  bool _isBuySelected = true;
  RangeValues _priceRange = RangeValues(0, 200000);
  RangeValues _areaRange = RangeValues(0, 200);
  int _selectedRooms = 0;
  int _selectedBathrooms = 0;
  @override
  void initState() {
    super.initState();
    DatabaseReference saleDatabaseRef =
        FirebaseDatabase.instance.reference().child('sale');
    DatabaseReference rentDatabaseRef =
        FirebaseDatabase.instance.reference().child('rent');
    saleDatabaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final estates = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          estatesAll = estates.entries
              .where((entry) => entry.value['isApproves'] == true)
              .map((entry) => Map<String, dynamic>.from(entry.value))
              .toList();
          applySearchByCity();
        });
      }
    });
    rentDatabaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final posts = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          postsAll.addAll(posts.entries
              .where((entry) => entry.value['isApproves'] == true)
              .map((entry) => Map<String, dynamic>.from(entry.value))
              .toList());
          applySearchByCity();
        });
      }
    });
  }

  void applySearchByCity() {
    setState(() {
      _estates = estatesAll
          .where((entry) =>
              entry['isApproves'] == true &&
                  (searchQuery.isEmpty ||
                      entry['city'].toString().contains(searchQuery)) ||
              entry['address1'].toString().contains(searchQuery))
          .map((entry) {
        final estate = Map<String, dynamic>.from(entry);
        List<String> imageUrls = [];
        if (estate['images'] != null) {
          final images = estate['images'] as Map<dynamic, dynamic>;
          if (images.isNotEmpty) {
            imageUrls = images.values.map((value) => value.toString()).toList();
          }
        }
        return Estate(
          images: imageUrls,
          city: estate['city'] as String,
          type: estate['type'] as String,
          description: estate['description'] as String,
          price: estate['price'] as int,
          numRooms: estate['numRooms'] as int,
          numBathrooms: estate['numBathrooms'] as int,
          size: estate['size'] as int,
          numVerandas: estate['numVerandas'] as int,
          address1: estate['address1'] as String,
          OwnerID: estate['OwnerID'] as String,
          longitude: (estate['longitude'] as num).toDouble(),
          latitude: (estate['latitude'] as num).toDouble(),
        );
      }).toList();
    });
  }

  void applySearchWithFilters() {
    setState(() {
      _estates = estatesAll
          .where((entry) =>
              (_isBuySelected || !_isRentSelected) &&
              entry['type'] == 'بيع' &&
              (entry['price'] >= _priceRange.start &&
                  entry['price'] <= _priceRange.end) &&
              (entry['size'] >= _areaRange.start &&
                  entry['size'] <= _areaRange.end) &&
              (_selectedRooms == 0 || entry['numRooms'] == _selectedRooms) &&
              (_selectedBathrooms == 0 ||
                  entry['numBathrooms'] == _selectedBathrooms))
          .map((entry) {
        final estate = Map<String, dynamic>.from(entry);
        List<String> imageUrls = [];
        if (estate['images'] != null) {
          final images = estate['images'] as Map<dynamic, dynamic>;
          if (images.isNotEmpty) {
            imageUrls = images.values.map((value) => value.toString()).toList();
          }
        }
        return Estate(
          images: imageUrls,
          city: estate['city'] as String,
          type: estate['type'] as String,
          description: estate['description'] as String,
          price: estate['price'] as int,
          numRooms: estate['numRooms'] as int,
          numBathrooms: estate['numBathrooms'] as int,
          size: estate['size'] as int,
          numVerandas: estate['numVerandas'] as int,
          address1: estate['address1'] as String,
          OwnerID: estate['OwnerID'] as String,
          longitude: (estate['longitude'] as num).toDouble(),
          latitude: (estate['latitude'] as num).toDouble(),
        );
      }).toList();

      _posts = postsAll
          .where((entry) =>
              (!_isBuySelected || _isRentSelected) &&
              entry['type'] == 'اجار' &&
              (entry['price'] >= _priceRange.start &&
                  entry['price'] <= _priceRange.end) &&
              (_selectedRooms == 0 || entry['numRooms'] == _selectedRooms) &&
              (_selectedBathrooms == 0 ||
                  entry['numBathrooms'] == _selectedBathrooms))
          .map((entry) {
        final post = Map<String, dynamic>.from(entry);
        List<String> imageUrls = [];
        if (post['images'] != null) {
          final images = post['images'] as Map<dynamic, dynamic>;
          if (images.isNotEmpty) {
            imageUrls = images.values.map((value) => value.toString()).toList();
          }
        }
        return Post(
          images: imageUrls,
          city: post['city'] as String,
          type: post['type'] as String,
          description: post['description'] as String,
          price: post['price'] as int,
          numRooms: post['numRooms'] as int,
          numBathrooms: post['numBathrooms'] as int,
          size: post['size'] as int,
          address1: post['address1'] as String,
          OwnerID: post['OwnerID'] as String,
          longitude: (post['longitude'] as num).toDouble(),
          latitude: (post['latitude'] as num).toDouble(),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            // width: 100,
            // height: 100,
            child: SizedBox(
                child: Stack(children: <Widget>[
          Positioned(
              // top: -10,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
              )),
          Positioned(
            top: -40,
            left: -60,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainScreen(currentIndex: widget.currentIndex)),
                );
              },
              child: Transform.scale(
                scale: 0.2,
                child: Image.asset('assets/icons/White_back.png'),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.75,
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: const Text(
                      "العقارات المتاحة للشراء",
                      style: TextStyle(
                        fontFamily: 'Scheherazade_New',
                        fontSize: 16,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 35, // or any other suitable value
                  left: 10,
                  right: 10, // or any other suitable value
                  child: SizedBox(
                    height: size.height - 250,
                    width: size.width -
                        40, // subtract the left and right padding from the total width
                    child: (_isBuySelected && !_isBuySelected)
                        ? ListView.builder(
                            itemCount: _estates.length,
                            itemBuilder: (context, index) {
                              final estate = _estates[index];

                              return MyCard(
                                estate: estate,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 7.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 310,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              color: primaryWhite,
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    estate.images.first),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          // Positioned(
                                          //   top: 10,
                                          //   right: 10,
                                          //   child: Icon(Icons.favorite_border,
                                          //       color: Colors.white),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // set alignment
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 13.0),
                                          child: Text(
                                            "\$" + estate.price.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: primaryRed,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 13.0),
                                          child: Text(
                                            '${estate.city} , ${estate.address1}',
                                            style: const TextStyle(
                                              fontFamily: 'Scheherazade_New',
                                              fontSize: 15,
                                              color: primaryRed,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // set alignment
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 6.0),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/icons/Red_bedroom.png'),
                                                width: 20,
                                                height: 18,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    5), // add some spacing between the icon and text

                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 6.0),
                                              child: Text(
                                                estate.numRooms.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: primaryRed,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 6.0),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/icons/Red_bathroom.png'),
                                                width: 20,
                                                height: 18,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    5), // add some spacing between the icon and text

                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 13.0),
                                              child: Text(
                                                estate.numBathrooms.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: primaryRed,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/icons/Red_size.png'),
                                                width: 20,
                                                height: 18,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    5), // add some spacing between the icon and text

                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 75.0),
                                              child: Text(
                                                estate.size.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: primaryRed,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 13.0),
                                          child: Text(
                                            estate.type,
                                            style: const TextStyle(
                                              fontFamily: 'Scheherazade_New',
                                              fontSize: 12,
                                              color: primaryRed,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: _estates.length + _posts.length,
                            itemBuilder: (context, index) {
                              if (index < _estates.length) {
                                final estate = _estates[index];

                                return MyCard(
                                  estate: estate,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 7.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 310,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: primaryWhite,
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      estate.images.first),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            // const Positioned(
                                            //   top: 10,
                                            //   right: 10,
                                            //   child: Icon(Icons.favorite_border,
                                            //       color: Colors.white),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, // set alignment
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 13.0),
                                            child: Text(
                                              "\$" + estate.price.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: primaryRed,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13.0),
                                            child: Text(
                                              estate.city,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: primaryRed,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, // set alignment
                                        children: [
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/icons/Red_bedroom.png'),
                                                  width: 20,
                                                  height: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      5), // add some spacing between the icon and text

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6.0),
                                                child: Text(
                                                  estate.numRooms.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: primaryRed,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/icons/Red_bathroom.png'),
                                                  width: 20,
                                                  height: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      5), // add some spacing between the icon and text

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 13.0),
                                                child: Text(
                                                  estate.numBathrooms
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: primaryRed,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 0.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/icons/Red_size.png'),
                                                  width: 20,
                                                  height: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      5), // add some spacing between the icon and text

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 75.0),
                                                child: Text(
                                                  estate.size.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: primaryRed,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13.0),
                                            child: Text(
                                              estate.type,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: primaryRed,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                final postIndex = index - _estates.length;
                                final post = _posts[postIndex];
                                return MySquare(
                                  post: post,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 7.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 310,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: primaryWhite,
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      post.images.first),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Icon(Icons.favorite_border,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, // set alignment
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 13.0),
                                            child: Text(
                                              "\$" + post.price.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: primaryRed,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13.0),
                                            child: Text(
                                              post.city,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: primaryRed,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, // set alignment
                                        children: [
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/icons/Red_bedroom.png'),
                                                  width: 20,
                                                  height: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      5), // add some spacing between the icon and text

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6.0),
                                                child: Text(
                                                  post.numRooms.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: primaryRed,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 6.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/icons/Red_bathroom.png'),
                                                  width: 20,
                                                  height: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      5), // add some spacing between the icon and text

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 13.0),
                                                child: Text(
                                                  post.numBathrooms.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: primaryRed,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 0.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/icons/Red_size.png'),
                                                  width: 20,
                                                  height: 18,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      5), // add some spacing between the icon and text

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 75.0),
                                                child: Text(
                                                  post.size.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: primaryRed,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13.0),
                                            child: Text(
                                              post.type,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: primaryRed,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size.width - size.width + 120,
            left: 10,
            child: Container(
              height: 50,
              width: size.width - 100,
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Material(
                color: Colors.transparent,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: InputBorder.none,
                    hintText: 'ابحث',
                    hintTextDirection: TextDirection.rtl,
                    suffixIcon: IconButton(
                      onPressed: () {
                        applySearchByCity();
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.width - size.width + 124,
            left: size.width - 78,
            right: 20,
            child: Container(
              height: size.width - 343,
              width: 20,
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(14.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: GestureDetector(
                child: Stack(
                  children: [
                    Positioned(
                      top: 3,
                      left: 3,
                      right: 3,
                      bottom: 3,
                      child: Transform.scale(
                        scale: 0.8,
                        child: Image.asset('assets/icons/Grey_filters.png'),
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  var result = await navigateToFiltersScreen(context);

                  if (result != null) {
                    setState(() {
                      _isRentSelected = result['isRentSelected'];
                      _isBuySelected = result['isBuySelected'];
                      _priceRange = result['priceRange'];
                      _areaRange = result['areaRange'];
                      _selectedRooms = result['selectedRooms'];
                      _selectedBathrooms = result['selectedBathrooms'];
                    });

                    applySearchWithFilters();
                  }
                },
              ),
            ),
          ),
        ]))));
  }

  Future<Map<String, dynamic>> navigateToFiltersScreen(
      BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersScreen(
          isRentSelected: _isRentSelected,
          isBuySelected: _isBuySelected,
          priceRange: _priceRange,
          areaRange: _areaRange,
          selectedRooms: _selectedRooms,
          selectedBathrooms: _selectedBathrooms,
          onFiltersApplied: (isRentSelected, isBuySelected, priceRange,
              areaRange, selectedRooms, selectedBathrooms) {
            setState(() {
              _isRentSelected = isRentSelected;
              _isBuySelected = isBuySelected;
              _priceRange = priceRange;
              _areaRange = areaRange;
              _selectedRooms = selectedRooms;
              _selectedBathrooms = selectedBathrooms;
            });
            print(_isRentSelected.toString() +
                ":" +
                _isBuySelected.toString() +
                ":" +
                _priceRange.toString() +
                ":" +
                _areaRange.toString() +
                ":" +
                _selectedRooms.toString() +
                ":" +
                _selectedBathrooms.toString());
          },
        ),
      ),
    );
    if (result == null) {
      return {
        'isRentSelected': true,
        'isBuySelected': true,
        'priceRange': RangeValues(0, 200000),
        'areaRange': RangeValues(0, 200),
        'selectedRooms': 0,
        'selectedBathrooms': 0,
      };
    }
    return result;
  }
}
