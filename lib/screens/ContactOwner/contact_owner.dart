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
  final String city;
  final String type;
  final int price;

  apartment({
    required this.city,
    required this.type,
    required this.price,
  });
}

class Myapartment extends apartment {
  final String city;
  final String type;
  final int price;

  Myapartment({
    required this.city,
    required this.type,
    required this.price,
  }) : super(city: city, type: type, price: price);
}

class Myapartment2 extends apartment {
  final String city;
  final String type;
  final int price;

  Myapartment2({
    required this.city,
    required this.type,
    required this.price,
  }) : super(city: city, type: type, price: price);
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
  helper models_helper=helper();
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
            return Myapartment(
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
            return Myapartment2(
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

  // Future<void> getUsersModels(String passedOwnerId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final sessionId = prefs.getString('sessionId');
  //   List<String> parts = sessionId!.split('.');
  //   id = parts[1].toString() + '.' + parts[2].toString();
  //   //get customer model
  //   QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //       .instance
  //       .collection("customers")
  //       .where("custId", isEqualTo: id.toString())
  //       .get();

  //   if (snapshot.docs.isNotEmpty) {
  //     QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  //         snapshot.docs[0];

  //     Map<String, dynamic> custdata = documentSnapshot.data();

  //     customer = CustModel.fromMap(custdata);
  //   }
  //   //get owner model
  //   QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore
  //       .instance
  //       .collection("owners")
  //       .where("ownerId", isEqualTo: passedOwnerId.toString())
  //       .get();

  //   if (snapshot2.docs.isNotEmpty) {
  //     QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot2 =
  //         snapshot2.docs[0];
  //     Map<String, dynamic> ownerdata = documentSnapshot2.data();

  //     owner = OwnerModel.fromMap(ownerdata);
  //   }
  // }

  Future<ChatRoomModel?> getChatRoomModel() async {
    ChatRoomModel? chatRoom;
String chatRoomId = "${models_helper.customer.custId}^${models_helper.owner.ownerId}";
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
       .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      // Fetch the existing one
      // var docData = snapshot.docs[0].data();
      // ChatRoomModel existingChatroom =
      //     ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      // chatRoom = existingChatroom;
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
              // backgroundImage: AssetImage('assets/icons//White_back.png'),
            ),
          ),
          Positioned(
            top: 255,
            left: size.width - 130,
            child: Text(
              fullName,
              style: TextStyle(
                  fontSize: 15,
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
                      ChatRoomModel? chatRoom =
                          await getChatRoomModel();
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
                                chatroom: chatRoom);
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
                  top: 470,
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: ListView.builder(
                    itemCount: _combineApartments().length,
                    itemBuilder: (BuildContext context, int index) {
                      final rentapart = _combineApartments()[index];
                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            'Apartment City: ${rentapart.city}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                'type: ${rentapart.type}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'price: ${rentapart.price}' as String,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
        ])));
  }
}
