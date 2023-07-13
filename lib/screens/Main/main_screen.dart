import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../guest_bottom_nav.dart';
import '../../owner_bottom_nav_bar.dart';
import '../../user_bottom_nav_bar.dart';
import '../BuyList/buylist_screen.dart';
import '../BuyList/card.dart';
import '../ContactOwner/Chatting_System/chats_screen.dart';
import 'dart:async';
import '../RentList/rentlist_screen.dart';
import '../RentList/square.dart';
import 'Search/search_screen.dart';

class MainScreen extends StatefulWidget {
  // String id="";
  final int currentIndex;
  // final String userSessionId;
  const MainScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool showRecommendation = false;
  bool variousApartments = true;
  late DatabaseReference saleDatabaseRef;
  late DatabaseReference rentDatabaseRef;
  List<Estate> _estates = [];
  List<Post> _posts = [];
  late String searchQuery = '';
  List<Map<String, dynamic>> allItems = [];

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
          allItems = estates.entries
              .where((entry) => entry.value['isApproves'] == true)
              .map((entry) => Map<String, dynamic>.from(entry.value))
              .toList();
          getApartments();
        });
      }
    });
    rentDatabaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final posts = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          allItems.addAll(posts.entries
              .where((entry) => entry.value['isApproves'] == true)
              .map((entry) => Map<String, dynamic>.from(entry.value))
              .toList());
          getApartments();
        });
      }
    });
  }

  void getApartments() {
    setState(() {
      _estates = allItems
          .where((entry) => entry['type'] == 'بيع' && (entry['price'] < 200000))
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

      _posts = allItems.where((entry) => entry['type'] == 'اجار').map((entry) {
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
            latitude: (post['latitude'] as num).toDouble());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var currentIndex = widget.currentIndex;
    return Container(
        color: Colors.transparent,
        child: SizedBox(
            child: Stack(children: <Widget>[
          Positioned(
              child: Scaffold(
            bottomNavigationBar: currentIndex == 1
                ? const BottomNavBar(
                    currentIndex: 0,
                  )
                : currentIndex == 0
                    ? const OwnerBottomNavBar(
                        currentIndex: 1,
                      )
                    : const GuestBottomNavBar(
                        currentIndex: 0,
                      ),
          )),
          Positioned(
              // top: -10,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
              )),
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
                        child: const Icon(
                          Icons.message,
                          color: primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => ChatsScreen(
                      number: 1,
                    ),
                  ));
                },
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: 25,
            right: 207,
            child: Container(
              height: 177,
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
              child: GestureDetector(
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 5,
                      right: 5,
                      bottom: 30,
                      child: Transform.scale(
                        scale: 1.0,
                        child: Image.asset('assets/icons/buy.png'),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Text(
                              "شراء عقار",
                              style: TextStyle(
                                fontFamily: 'Scheherazade_New',
                                fontSize: 17,
                                color: primaryRed,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BuyListScreen(currentIndex: widget.currentIndex),
                  ));
                },
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: 207,
            right: 25,
            child: Container(
              height: 177,
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
              child: GestureDetector(
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 5,
                      right: 5,
                      bottom: 30,
                      child: Transform.scale(
                        scale: 1.0,
                        child: Image.asset('assets/icons/rent.png'),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Text(
                              "استئجار عقار",
                              style: TextStyle(
                                fontFamily: 'Scheherazade_New',
                                fontSize: 17,
                                color: primaryRed,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => RentListScreen(
                            currentIndex: widget.currentIndex,
                          )));
                },
              ),
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
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(
                                currentIndex: widget.currentIndex,
                              )),
                    );
                  },
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                      hintText: 'ابحث',
                      hintTextDirection: TextDirection.rtl,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    enabled: false,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height - 400,
            left: 30,
            right: 30,
            bottom: 70,
            child: Container(
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontFamily: 'Scheherazade_New',
                              ),
                              child: Text(
                                'مدن مختلفة',
                              ),
                            ),
                            SizedBox(width: 8),
                            Image.asset(
                              'assets/icons/map.png',
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                      width: size.width,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/ram.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: const Center(
                                  child: Text(
                                'رام الله',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Scheherazade_New',
                                  decoration: TextDecoration.none,
                                ),
                              )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/beth.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: const Center(
                                  child: Text(
                                'بيت لحم',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Scheherazade_New',
                                  decoration: TextDecoration.none,
                                ),
                              )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/tul.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: const Center(
                                  child: Text(
                                'طولكرم',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Scheherazade_New',
                                  decoration: TextDecoration.none,
                                ),
                              )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/nab.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: const Center(
                                  child: Text(
                                'نابلس',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Scheherazade_New',
                                  decoration: TextDecoration.none,
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Scheherazade_New',
                                  ),
                                  child: Text(
                                    'عقارات متنوعة',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Image.asset(
                                  'assets/icons/hall.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(children: [
                      SizedBox(
                        height: size.width - 170,
                        width: size.width - 40,
                        child: ListView.separated(
                          reverse: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 30.0);
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            if (index < 5) {
                              if (_estates.isNotEmpty &&
                                  index < _estates.length) {
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
                                              width: size.width - 140,
                                              height: size.width - 265,
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
                                            padding: const EdgeInsets.only(
                                                top: 8, right: 5),
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
                                                    right: 13.0),
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
                                                    right: 10.0),
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
                                                left: 13.0),
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
                                return Container();
                              }
                            } else {
                              if (_posts.isNotEmpty &&
                                  index - 5 < _posts.length) {
                                final post = _posts[index - 5];
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
                                              width: size.width - 140,
                                              height: size.width - 265,
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
                                            padding: const EdgeInsets.only(
                                                top: 8, right: 5),
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
                                                    right: 13.0),
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
                                                    right: 10.0),
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
                              } else {
                                return Container();
                              }
                            }
                          },
                        ),
                      ),
                    ]),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Scheherazade_New',
                                  ),
                                  child: Text(
                                    'عقارات مقترحة لك',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Image.asset(
                                  'assets/icons/star.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ])));
  }
}
