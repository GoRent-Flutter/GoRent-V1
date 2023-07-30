import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:gorent_application1/user_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../BuyList/buylist_screen.dart';
import '../BuyList/card.dart';
import '../RentList/rentlist_screen.dart';
import '../RentList/square.dart';

class Favs {
  final List<String> images;
  final String apartmentcity;
  final String type;
  final int price;
  final int numRooms;
  final int numBathrooms;
  final int size;
  final String address1;
  final double longitude;
  final double latitude;

  Favs({
    required this.images,
    required this.apartmentcity,
    required this.type,
    required this.price,
    required this.numRooms,
    required this.numBathrooms,
    required this.size,
    required this.address1,
    required this.longitude,
    required this.latitude,
  });
}

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late String mergedID = "";
  late DatabaseReference _databaseRef;
  List<Favs> favouriteList = [];

  List<Estate> _estates = [];
  List<Post> _posts = [];
  List<Map<String, dynamic>> allItems = [];

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    List<String> parts = sessionId!.split('.');

    if (sessionId != null) {
      List<String> parts = sessionId.split('.');
      mergedID = parts[1].toString() + "." + parts[2].toString();
      print('llllllllll' + mergedID);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _databaseRef = FirebaseDatabase.instance.reference().child('watchlist');
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final watchlist = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          allItems = watchlist.entries
              .where((entry) => entry.value['custUsername'] == mergedID)
              .map((entry) => Map<String, dynamic>.from(entry.value))
              .toList();
          //print(allItems);

          // Separate the data into _estates and _posts lists based on the 'type'
          _estates = allItems
              .where((item) => item['type'] == 'بيع')
              .map((item) => Estate(
                    images: (item['images'] as List<dynamic>)
                        .map((image) => image.toString())
                        .toList(),
                    city: item['apartmentcity'] as String,
                    type: item['type'] as String,
                    price: item['price'] as int,
                    numRooms: item['numRooms'] as int,
                    numBathrooms: item['numBathrooms'] as int,
                    size: item['size'] as int,
                    address1: item['address1'] as String,
                    description: item['description'] as String,
                    numVerandas:
                        item['price'] as int, // Include numVerandas for Estate
                    OwnerID: item['apartmentOwnerId']
                        as String, // Include OwnerID for Estate
                    longitude: item['longitude']
                        as double, // Include longitude for Estate
                    latitude: item['latitude']
                        as double, // Include latitude for Estate
                  ))
              .toList();
          print(_estates);

          _posts = allItems
              .where((item) => item['type'] == 'اجار')
              .map((item) => Post(
                    images: (item['images'] as List<dynamic>)
                        .map((image) => image.toString())
                        .toList(),
                    city: item['apartmentcity'] as String,
                    type: item['type'] as String,
                    price: item['price'] as int,
                    numRooms: item['numRooms'] as int,
                    numBathrooms: item['numBathrooms'] as int,
                    size: item['size'] as int,
                    address1: item['address1'] as String,
                    description: item['description'] as String,
                    // numVerandas: item['price'] as int, // Include numVerandas for Estate
                    OwnerID: item['apartmentOwnerId']
                        as String, // Include OwnerID for Estate
                    longitude: item['longitude']
                        as double, // Include longitude for Estate
                    latitude: item['latitude']
                        as double, // Include latitude for Estate
                  ))
              .toList();
          print(_posts);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: primaryGrey,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Scaffold(
              bottomNavigationBar: BottomNavBar(currentIndex: 1),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: 1.08,
              child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
            ),
          ),
          // Positioned(
          //   top: -40,
          //   left: -50,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const MainScreen(
          //             currentIndex: 1,
          //           ),
          //         ),
          //       );
          //     },
          //     child: Transform.scale(
          //       scale: 0.2,
          //       child: Image.asset('assets/icons/White_back.png'),
          //     ),
          //   ),
          // ),
          Positioned(
            top: 130,
            left: 25,
            right: 25,
            child: Container(
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
          ),
          Positioned(
            top: 180,
            left: size.width / 2 - 60,
            child: const Text(
              "العقارات المفضلة",
              style: TextStyle(
                fontFamily: 'Scheherazade_New',
                fontSize: 20,
                color: primaryRed,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            top: 210,
            left: 32,
            right: 32,
            bottom: 80,
            child: allItems.isEmpty
                ? Center(
                    child: Text(
                      'لا يوجد عقارات مفضلة لديك',
                      style: TextStyle(
                        fontFamily: 'Scheherazade_New',
                        fontSize: 18,
                        color: primaryRed,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _estates.length + _posts.length,
                    itemBuilder: (context, index) {
                      if (index < _estates.length) {
                        // Display MyCard for buylist
                        final estate = _estates[index];
                        return MyCard(
                          estate: estate,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7, left: 7, right: 7),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: size.width - 50,
                                      height: size.width - 240,
                                      decoration: BoxDecoration(
                                        color: primaryWhite,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(estate.images.first),
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
                                    padding: EdgeInsets.only(
                                        top: 8,
                                        left: 5.0,
                                        right: size.width - 265),
                                    child: Text(
                                      "\$" + estate.price.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: primaryRed,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 9),
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
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // set alignment
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            right: 9.0, left: 9),
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
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          estate.numRooms.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryRed,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 6.0),
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
                                        padding:
                                            const EdgeInsets.only(right: 13.0),
                                        child: Text(
                                          estate.numBathrooms.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryRed,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 0.0),
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          estate.size.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryRed,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, right: 9),
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
                        // Display MySquare for rent data
                        final postIndex = index - _estates.length;
                        final post = _posts[postIndex];
                        return MySquare(
                          post: post,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7, left: 7, right: 7),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: size.width - 50,
                                      height: size.width - 240,
                                      decoration: BoxDecoration(
                                        color: primaryWhite,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(post.images.first),
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
                                    padding: EdgeInsets.only(
                                        top: 8,
                                        left: 5.0,
                                        right: size.width - 265),
                                    child: Text(
                                      "\$" + post.price.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: primaryRed,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 8),
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
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // set alignment
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            right: 13.0, left: 8),
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
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          post.numRooms.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryRed,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 6.0),
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
                                        padding:
                                            const EdgeInsets.only(right: 13.0),
                                        child: Text(
                                          post.numBathrooms.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryRed,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 0.0),
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          post.size.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryRed,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 13.0),
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
        ],
      ),
    );
  }
}
