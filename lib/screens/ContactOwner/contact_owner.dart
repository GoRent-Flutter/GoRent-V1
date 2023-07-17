import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_database/firebase_database.dart' as firebase;
import 'package:uuid/uuid.dart';

import '../Models_Folder/CustModel.dart';
import '../Models_Folder/OwnerModel.dart';
import '../RentList/rentlist_screen.dart';
import 'Chatting_System/chat_room_model.dart';
import 'Chatting_System/chat_room_screen.dart';
import 'Chatting_System/user_models_helper.dart';

class apartment {
  final List<String> images;
  final String city;
  final String type;
  final int price;

  apartment({
    required this.images,
    required this.city,
    required this.type,
    required this.price,
  });
}

class Myapartment extends apartment {
  final List<String> images;
  final String city;
  final String type;
  final int price;

  Myapartment({
    required this.images,
    required this.city,
    required this.type,
    required this.price,
  }) : super(city: city, type: type, price: price, images: images);
}

class Myapartment2 extends apartment {
  final List<String> images;
  final String city;
  final String type;
  final int price;

  Myapartment2({
    required this.images,
    required this.city,
    required this.type,
    required this.price,
  }) : super(city: city, type: type, price: price, images: images);
}

class ContactOwnerScreen extends StatefulWidget {
  final String ownerID;

  const ContactOwnerScreen({Key? key, required this.ownerID}) : super(key: key);

  @override
  ContactOwnerState createState() => ContactOwnerState();
}

class ContactOwnerState extends State<ContactOwnerScreen> {
  bool propertiesInfo = true;
  bool aboutOwner = false;
  helper models_helper = helper();
  // late CustModel customer;
  // late OwnerModel owner;
  // late String id;
  firestore.DocumentSnapshot? ownerSnapshot;
  late DatabaseReference _databaseRef;
  late DatabaseReference _databaseRef2;
  List<Myapartment> _Myapartment = [];
  List<Myapartment2> _Myapartment2 = [];
  // List<apartment> _combinedList = [];

  @override
  void initState() {
    super.initState();
    models_helper.getUsersModels(widget.ownerID);
    fetchOwnerData();
    _databaseRef = FirebaseDatabase.instance.reference().child('rent');
    _databaseRef2 = FirebaseDatabase.instance.reference().child('sale');
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final rentmyapartment = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          _Myapartment = rentmyapartment.entries
              .where((entry) => entry.value['OwnerID'] == widget.ownerID)
              .map((entry) {
            final rentedapartment = Map<String, dynamic>.from(entry.value);

            List<String> imageUrls = [];
            if (rentedapartment['images'] != null) {
              final images = rentedapartment['images'] as Map<dynamic, dynamic>;
              if (images.isNotEmpty) {
                imageUrls =
                    images.values.map((value) => value.toString()).toList();
              }
            }
            return Myapartment(
              images: imageUrls,
              city: rentedapartment['city'] as String,
              type: rentedapartment['type'] as String,
              price: rentedapartment['price'] as int,
            );
          }).toList();
        });
      }
    });
    _databaseRef2.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final salemyapartment = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          _Myapartment2 = salemyapartment.entries
              .where((entry) => entry.value['OwnerID'] == widget.ownerID)
              .map((entry) {
            final saleapartment = Map<String, dynamic>.from(entry.value);
            List<String> imageUrls = [];
            if (saleapartment['images'] != null) {
              final images = saleapartment['images'] as Map<dynamic, dynamic>;
              if (images.isNotEmpty) {
                imageUrls =
                    images.values.map((value) => value.toString()).toList();
              }
            }
            return Myapartment2(
              images: imageUrls,
              city: saleapartment['city'] as String,
              type: saleapartment['type'] as String,
              price: saleapartment['price'] as int,
            );
          }).toList();
        });
      }
    });
  }

  List<apartment> _combineApartments() {
    List<apartment> combinedList = [];
    combinedList.addAll(_Myapartment);
    combinedList.addAll(_Myapartment2);
    return combinedList;
  }

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

  Future<ChatRoomModel?> getChatRoomModel() async {
    ChatRoomModel? chatRoom;
    String chatRoomId =
        "${models_helper.customer.custId}^${models_helper.owner.ownerId}";
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("chatrooms")
          .where("chatRoomId", isEqualTo: chatRoomId.toString())
          .get();

      if (snapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            snapshot.docs[0];

        Map<String, dynamic> chatdata = documentSnapshot.data();

        chatRoom = ChatRoomModel.fromMap(chatdata);
      }
      print("ALREADY EXISTS");
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatRoomId: chatRoomId,
        lastMessage: "",
        participants: {
          models_helper.customer.custId.toString(): true,
          models_helper.owner.ownerId.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatRoomId)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
    }

    return chatRoom;
  }

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
    // final cleanedPhoneNumber = phoneNumber.replaceAll(
    //     RegExp(r'\D'), ''); // Remove non-digit characters

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
              backgroundImage: AssetImage('assets/icons/user.png'),
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
                  fontFamily: 'Scheherazade_New',
                  fontSize: 18,
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
                    onPressed: () async {
                      //direct trans
                      launch('tel:$phoneNumber');
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
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child:
                                CircularProgressIndicator(), // Show a circular progress indicator
                          );
                        },
                      );
                      ChatRoomModel? chatRoom = await getChatRoomModel();
                      Navigator.pop(context); // Dismiss the progress indicator

                      if (models_helper.customer != null &&
                          models_helper.owner != null &&
                          chatRoom != null) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ChatRoomScreen(
                              customer: models_helper.customer,
                              owner: models_helper.owner,
                              chatroom: chatRoom,
                              number: 1,
                            );
                          }),
                        );
                      }
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
                              fontFamily: 'Scheherazade_New',
                              decoration: TextDecoration.none,
                              fontSize: 20,
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
                              fontFamily: 'Scheherazade_New',
                              decoration: TextDecoration.none,
                              fontSize: 20,
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
                        fontFamily: 'Scheherazade_New',
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
                        fontFamily: 'Scheherazade_New',
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
                        fontFamily: 'Scheherazade_New',
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
                        fontFamily: 'Scheherazade_New',
                        fontSize: 18,
                        color: primaryRed,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ])
              : Positioned(
                  top: 470,
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: ListView.builder(
                    itemCount: _combineApartments().length,
                    itemBuilder: (BuildContext context, int index) {
                      final rentapart = _combineApartments()[index];
                      return Material(
                        child: InkWell(
                          onTap: () {
                            // Handle post click
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
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
                                        width: 150,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                rentapart.images.first),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 100),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rentapart.city,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            rentapart.type,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '${rentapart.price} \$',
                                            style: TextStyle(
                                              fontSize: 16,
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
                  )),
        ])));
  }
}
