import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/ItemDetail/itemdetailrent_screen.dart';
import 'package:gorent_application1/screens/RentList/square.dart';
import 'package:flutter/widgets.dart';

import '../Filters/filters.dart';
import '../Main/main_screen.dart';

class Post {
  final List<String> images;
  final String city;
  final String type;
  final String description;
  final int price;
  final int numRooms;
  final int numBathrooms;
  final int size;
  final String address1;
  final String OwnerID; // Add ownerID field

  Post({
    required this.images,
    required this.city,
    required this.type,
    required this.description,
    required this.price,
    required this.numRooms,
    required this.numBathrooms,
    required this.size,
    required this.address1,
    required this.OwnerID, // Initialize ownerID field
  });
}

class RentListScreen extends StatefulWidget {
  final int currentIndex;
  RentListScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _RentListScreenState createState() => _RentListScreenState();
}

class _RentListScreenState extends State<RentListScreen> {
  late String searchQuery = '';
  late DatabaseReference _databaseRef;
  List<Post> _posts = [];
  List<Map<String, dynamic>> postsAll = [];

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('rent');
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final posts = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          postsAll = posts.entries
              .where((entry) => entry.value['isApproves'] == true)
              .map((entry) => Map<String, dynamic>.from(entry.value))
              .toList();
          applySearchByCity();
        });
      }
    });
  }

  void applySearchByCity() {
    setState(() {
      _posts = postsAll
          .where((entry) =>
              entry['isApproves'] == true &&
              (searchQuery.isEmpty ||
                  entry['city'].toString().contains(searchQuery)) || entry['address1'].toString().contains(searchQuery))
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
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
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
                  height: size1.height * 0.75,
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
                      "العقارات المتاحة للإيجار",
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
                  top: 35,
                  left: 10,
                  right: 10,
                  child: SizedBox(
                    height: size1.height - 250,
                    width: size1.width -
                        40, // subtract the left and right padding from the total width
                    child: ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return MySquare(
                          post: post,
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
                                    Positioned(
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
                                    padding: EdgeInsets.only(left: 13.0),
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
                                    padding: EdgeInsets.only(right: 13.0),
                                    child: Text(
                                      '${post.city} , ${post.address1}',
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
                                        padding: EdgeInsets.only(left: 6.0),
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
                                        padding: EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          post.numRooms.toString(),
                                          style: TextStyle(
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
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0),
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
                                        padding: EdgeInsets.only(right: 13.0),
                                        child: Text(
                                          post.numBathrooms.toString(),
                                          style: TextStyle(
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
                                      Padding(
                                        padding: EdgeInsets.only(left: 0.0),
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
                                        padding: EdgeInsets.only(right: 75.0),
                                        child: Text(
                                          post.size.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: primaryRed,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 13.0),
                                    child: Text(
                                      post.type,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size1.width - size1.width + 120,
            left: 10,
            child: Container(
              height: 50,
              width: size1.width - 100,
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
            top: size1.width - size1.width + 124,
            left: size1.width - 78,
            right: 20,
            child: Container(
              height: size1.width - 343,
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
                onTap: () {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (BuildContext context) =>  FiltersScreen(),
                  // ));
                },
              ),
            ),
          ),
        ]))));
  }
}
