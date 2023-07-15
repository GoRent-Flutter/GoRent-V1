import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:gorent_application1/user_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favs {
  final List<String> images;
  final String apartmentcity;
  final String type;
  final int price;
  final int numRooms;
  final int numBathrooms;
  final int size;
  final String address1;

  Favs({
    required this.images,
    required this.apartmentcity,
    required this.type,
    required this.price,
    required this.numRooms,
    required this.numBathrooms,
    required this.size,
    required this.address1,
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
        final favs = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          favouriteList = favs.entries
              .where((entry) => entry.value['custUsername'] == mergedID)
              .map((entry) {
            final fav = Map<String, dynamic>.from(entry.value);
            // List<String> imageUrls = [];
            // if (fav['images'] != null) {
            //   final images = fav['images'] as Map<dynamic, dynamic>;
            //   if (images.isNotEmpty) {
            //     imageUrls =
            //         images.values.map((value) => value.toString()).toList();
            //   }
            // }
            return Favs(
              images: (fav['images'] as List<dynamic>)
                  .map((image) => image.toString())
                  .toList(),
              apartmentcity: fav['apartmentcity'] as String,
              type: fav['type'] as String,
              price: fav['price'] as int,
              numRooms: fav['numRooms'] as int,
              numBathrooms: fav['numBathrooms'] as int,
              size: fav['size'] as int,
              address1: fav['address1'] as String,
            );
          }).toList();
          //print(favouriteList);
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
          Positioned(
            top: -40,
            left: -50,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(
                      currentIndex: 1,
                    ),
                  ),
                );
              },
              child: Transform.scale(
                scale: 0.2,
                child: Image.asset('assets/icons/White_back.png'),
              ),
            ),
          ),
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
            child: favouriteList.isEmpty
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
                    itemCount: favouriteList.length,
                    itemBuilder: (context, index) {
                      final fav = favouriteList[index];
                      return Material(
                        child: InkWell(
                          onTap: () {
                            // Handle post click
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(fav.images.first),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fav.apartmentcity,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            fav.type,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 2.0),
                                                    child: Image(
                                                      image: AssetImage(
                                                        'assets/icons/Red_bedroom.png',
                                                      ),
                                                      width: 10,
                                                      height: 10,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 6.0),
                                                    child: Text(
                                                      ' ${fav.numRooms}',
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
                                                    padding: EdgeInsets.only(
                                                        left: 2.0),
                                                    child: Image(
                                                      image: AssetImage(
                                                        'assets/icons/Red_bathroom.png',
                                                      ),
                                                      width: 10,
                                                      height: 10,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 13.0),
                                                    child: Text(
                                                      ' ${fav.numBathrooms}',
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
                                                    padding: EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Image(
                                                      image: AssetImage(
                                                        'assets/icons/Red_size.png',
                                                      ),
                                                      width: 10,
                                                      height: 10,
                                                    ),
                                                  ),
                                                  SizedBox(width: 1),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 75.0),
                                                    child: Text(
                                                      ' ${fav.size}',
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
                                            ],
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            '${fav.price} \$',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: primaryRed,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
