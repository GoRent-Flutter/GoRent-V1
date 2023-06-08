import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_database/firebase_database.dart' as firebase;

import '../RentList/rentlist_screen.dart';

class ContactOwnerScreen extends StatefulWidget {
  final String ownerID;

  const ContactOwnerScreen({Key? key, required this.ownerID}) : super(key: key);

  @override
  ContactOwnerState createState() => ContactOwnerState();
}

class ContactOwnerState extends State<ContactOwnerScreen> {
  bool propertiesInfo = true;
  bool aboutOwner = false;
  firestore.DocumentSnapshot? ownerSnapshot;

  // List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    fetchOwnerData();
    // fetchApartments();
  }

  List<String> apartments = [];
  Future<void> fetchOwnerData() async {
    try {
      final firestore.DocumentSnapshot snapshot = await firestore
          .FirebaseFirestore.instance
          .collection('owners')
          .doc(widget.ownerID)
          .get();
      setState(() {
        ownerSnapshot = snapshot;
      });
      // fetchApartments(); // Fetch apartments after owner data is fetched
    } catch (e) {
      print('Error fetching owner data: $e');
    }
  }

  // Future<void> fetchApartments() async {
  //   try {
  //     final databaseReference = FirebaseDatabase.instance.reference();
  //     final rentSnapshot = await databaseReference
  //         .child('rent')
  //         .orderByChild('OwnerID')
  //         .equalTo(widget.ownerID)
  //         .once();
  //     final buySnapshot = await databaseReference
  //         .child('buy')
  //         .orderByChild('OwnerID')
  //         .equalTo(widget.ownerID)
  //         .once();

  //     final List<String> rentedApartments = [];
  //     final List<String> boughtApartments = [];

  //     if (rentSnapshot.snapshot.value != null) {
  //       final Map<dynamic, dynamic>? rentData =
  //           rentSnapshot.snapshot.value as Map?;
  //       rentData?.forEach((key, value) {
  //         rentedApartments.add(
  //             key as String); // Assuming each key represents an apartment ID
  //       });
  //     }

  //     if (buySnapshot.snapshot.value != null) {
  //       final Map<dynamic, dynamic>? buyData =
  //           buySnapshot.snapshot.value as Map?;
  //       buyData?.forEach((key, value) {
  //         boughtApartments.add(
  //             key as String); // Assuming each key represents an apartment ID
  //       });
  //     }

  //     setState(() {
  //       apartments = [...rentedApartments, ...boughtApartments];
  //       print(apartments);
  //     });
  //   } catch (e) {
  //     print('Error fetching apartments: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (ownerSnapshot == null) {
      // Show a loading indicator or any other fallback UI
      return Center(child: CircularProgressIndicator());
    }

    final ownerData = ownerSnapshot!.data() as Map<String, dynamic>;
    final fullName = ownerData['fullname'] as String;
    final email = ownerData['email'] as String;
    final phoneNumber = ownerData['phone_number'] as String;
    final city = ownerData['city'] as String;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            child: Stack(children: <Widget>[
          Positioned(
              // top: -10,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.0,
                child: Image.asset('assets/images/GoRent_cover.png'),
              )),
          Positioned(
            top: -40,
            left: -60,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Transform.scale(
                scale: 0.2,
                child: Image.asset('assets/icons/White_back.png'),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: size.width - 150,
            right: 5,
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white70,
              // backgroundImage: AssetImage('assets/icons//White_back.png'),
            ),
          ),
          Positioned(
            top: 255,
            left: size.width - 120,
            child: Text(
              fullName,
              style: TextStyle(
                  fontSize: 23,
                  color: primaryRed,
                  decoration: TextDecoration.none),
            ),
          ),
          Positioned(
            top: 290,
            left: size.width - 100,
            child: Text(
              city,
              style: TextStyle(
                  fontSize: 15,
                  color: primaryHint.withOpacity(0.6),
                  decoration: TextDecoration.none),
            ),
          ),
          Positioned(
            top: 330,
            left: 5,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextButton(
                    onPressed: () {
                      //direct trans
                      launch(phoneNumber);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      minimumSize: const Size(165, 45),
                    ),
                    child: const Text(
                      'الإتصال',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const MainScreen()),
                      // );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      minimumSize: const Size(165, 45),
                    ),
                    child: const Text(
                      'المراسلة',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: size.height - 380,
              left: 35,
              right: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        propertiesInfo = true;
                        aboutOwner = false;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "العقارات",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 21,
                              color: propertiesInfo ? primaryLine : primaryRed),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          height: 1,
                          width: 100,
                          color:
                              propertiesInfo ? primaryLine : Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        propertiesInfo = false;
                        aboutOwner = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "عن المالك",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 21,
                              color: aboutOwner ? primaryLine : primaryRed),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          height: 1,
                          width: 100,
                          color: aboutOwner ? primaryLine : Colors.transparent,
                        )
                      ],
                    ),
                  ),
                ],
              )),
          aboutOwner
              ? Stack(children: <Widget>[
                  Positioned(
                    top: size.height - 320,
                    left: size.width - 140,
                    child: const Text(
                      "البريد الإلكتروني",
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  //  SizedBox(height: 10),
                  Positioned(
                    top: size.height - 280,
                    left: size.width - 190,
                    child: Text(
                      email,
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height - 230,
                    left: size.width - 110,
                    child: const Text(
                      "رقم الهاتف",
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height - 190,
                    left: size.width - 140,
                    child: Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ])
              : Positioned(
                  top: size.height - 330,
                  left: 30,
                  right: 30,
                  child: const Text(
                    "not available yet",
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryRed,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
          // Material(
          //     child: Positioned(
          //     top: 470,
          //     left: 20,
          //     right: 20,
          //     bottom: 20,
          // child: ListView.builder(
          //   itemCount: apartments.length,
          //   itemBuilder: (context, index) {
          //     final apartmentId = apartments[index];
          //     child:
          //     Column(
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(top: 7.0),
          //           child: Stack(
          //             children: [
          //               Container(
          //                 width: 310,
          //                 height: 150,
          //                 decoration: BoxDecoration(
          //                   color: primaryWhite,
          //                   borderRadius: BorderRadius.circular(24.0),
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black.withOpacity(0.3),
          //                       spreadRadius: 2,
          //                       blurRadius: 5,
          //                     ),
          //                   ],
          //                   // image: DecorationImage(
          //                   //   image: NetworkImage(apartmentId.images.first),
          //                   //   fit: BoxFit.cover,
          //                   // ),
          //                 ),
          //               ),
          //               Positioned(
          //                 top: 10,
          //                 right: 10,
          //                 child: Icon(Icons.favorite_border,
          //                     color: Colors.white),
          //               ),
          //             ],
          //           ),
          //         ),
          //         Row(
          //           mainAxisAlignment:
          //               MainAxisAlignment.spaceBetween, // set alignment
          //           children: [
          //             Padding(
          //               padding: EdgeInsets.only(left: 13.0),
          //               child: Text(
          //                 "\$ + post.price.toString()",
          //                 style: const TextStyle(
          //                   fontSize: 12,
          //                   color: primaryRed,
          //                   decoration: TextDecoration.none,
          //                 ),
          //               ),
          //             ),
          //             Padding(
          //               padding: EdgeInsets.only(right: 13.0),
          //               child: Text(
          //                 'Apartment ID: $apartmentId',
          //                 style: const TextStyle(
          //                   fontFamily: 'Scheherazade_New',
          //                   fontSize: 16,
          //                   color: primaryRed,
          //                   decoration: TextDecoration.none,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment:
          //               MainAxisAlignment.spaceBetween, // set alignment
          //           children: [
          //             Row(
          //               children: [
          //                 Padding(
          //                   padding: EdgeInsets.only(left: 6.0),
          //                   child: Image(
          //                     image: AssetImage(
          //                         'assets/icons/Red_bedroom.png'),
          //                     width: 20,
          //                     height: 18,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                     width:
          //                         5), // add some spacing between the icon and text

          //                 Padding(
          //                   padding: EdgeInsets.only(right: 6.0),
          //                   // child: Text(
          //                   //   post.numRooms.toString(),
          //                   //   style: TextStyle(
          //                   //     fontSize: 12,
          //                   //     color: primaryRed,
          //                   //     decoration: TextDecoration.none,
          //                   //   ),
          //                   // ),
          //                 ),
          //               ],
          //             ),
          //             Row(
          //               children: [
          //                 Padding(
          //                   padding: EdgeInsets.only(left: 6.0),
          //                   child: Image(
          //                     image: AssetImage(
          //                         'assets/icons/Red_bathroom.png'),
          //                     width: 20,
          //                     height: 18,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                     width:
          //                         5), // add some spacing between the icon and text

          //                 Padding(
          //                   padding: EdgeInsets.only(right: 13.0),
          //                   // child: Text(
          //                   //   post.numBathrooms.toString(),
          //                   //   style: TextStyle(
          //                   //     fontSize: 12,
          //                   //     color: primaryRed,
          //                   //     decoration: TextDecoration.none,
          //                   //   ),
          //                   // ),
          //                 ),
          //               ],
          //             ),
          //             Row(
          //               children: [
          //                 Padding(
          //                   padding: EdgeInsets.only(left: 0.0),
          //                   child: Image(
          //                     image: AssetImage(
          //                         'assets/icons/Red_size.png'),
          //                     width: 20,
          //                     height: 18,
          //                   ),
          //                 ),
          //                 SizedBox(
          //                     width:
          //                         5), // add some spacing between the icon and text

          //                 Padding(
          //                   padding: EdgeInsets.only(right: 75.0),
          //                   // child: Text(
          //                   //   post.size.toString(),
          //                   //   style: TextStyle(
          //                   //     fontSize: 12,
          //                   //     color: primaryRed,
          //                   //     decoration: TextDecoration.none,
          //                   //   ),
          //                   // ),
          //                 ),
          //               ],
          //             ),
          //             Padding(
          //               padding: EdgeInsets.only(right: 13.0),
          //               // child: Text(
          //               //   post.type,
          //               //   style: const TextStyle(
          //               //     fontFamily: 'Scheherazade_New',
          //               //     fontSize: 12,
          //               //     color: primaryRed,
          //               //     decoration: TextDecoration.none,
          //               //   ),
          //               // ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     );
          //   },
          // ),
          // Add Material widget here

          // child: ListView.builder(
          //   itemCount: apartments.length,
          //   itemBuilder: (context, index) {
          //     final apartmentId = apartments[index];
          //     return FutureBuilder(
          //       //future: fetchApartmentDetails(apartmentId),
          //       builder: (context, snapshot) {
          //         if (snapshot.connectionState ==
          //             ConnectionState.waiting) {
          //           return CircularProgressIndicator();
          //         } else if (snapshot.hasError) {
          //           return Text('Error fetching apartment details.');
          //         } else if (snapshot.hasData) {
          //           final apartment = snapshot.data
          //               as Apartment; // Replace `Apartment` with your apartment data model
          //           return ApartmentWidget(
          //             images: apartment.images,
          //             city: apartment.city,
          //             type: apartment.type,
          //             description: apartment.description,
          //             price: apartment.price,
          //             numRooms: apartment.numRooms,
          //             numBathrooms: apartment.numBathrooms,
          //             size: apartment.size,
          //           );
          //         } else {
          //           return Text('Apartment data not available.');
          //         }
          //       },
          //     );
          //   },
          // ),
          // ))
        ])));
  }
}
