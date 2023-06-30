import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/ContactOwner/Chatting_System/chat_room_model.dart';
import 'package:gorent_application1/screens/ContactOwner/Chatting_System/user_models_helper.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models_Folder/CustModel.dart';
import '../../Models_Folder/OwnerModel.dart';
import '../../owner_view/owner_view_screen.dart';
import 'chat_room_screen.dart';

class ChatsScreen extends StatefulWidget {
  int number; //0 for owners and 1 for customers
  ChatsScreen({Key? key, required this.number}) : super(key: key);

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  late Future<CustModel> customerFuture;
  late Future<OwnerModel> ownerFuture;
  helper user_models_helper = helper();

  @override
  void initState() {
    super.initState();
    if(widget.number==0){
    ownerFuture=getOwnerModel();
    }
    else{
    customerFuture = getCustomerModel();

    }
  }
//for customer
  Future<CustModel> getCustomerModel() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    List<String> parts = sessionId!.split('.');
    String id = parts[1].toString() + '.' + parts[2].toString();
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("customers")
        .where("custId", isEqualTo: id.toString())
        .get();

    if (snapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          snapshot.docs[0];

      Map<String, dynamic> custdata = documentSnapshot.data();
      return CustModel.fromMap(custdata);
    }
    throw Exception("Failed to fetch customer model");
  }

  Future<OwnerModel> getOwners(String ownerId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("owners")
        .doc(ownerId)
        .get();

    Map<String, dynamic> ownerData = snapshot.data()!;
    return OwnerModel.fromMap(ownerData);
  }
/////////////////////////////////////////////////////////////////////////////////
  //for owners
   Future<OwnerModel> getOwnerModel() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    List<String> parts = sessionId!.split('.');
    String id = parts[1].toString() + '.' + parts[2].toString();
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("owners")
        .where("ownerId", isEqualTo: id.toString())
        .get();

    if (snapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          snapshot.docs[0];

      Map<String, dynamic> ownerdata = documentSnapshot.data();
      return OwnerModel.fromMap(ownerdata);
    }
    throw Exception("Failed to fetch customer model");
  }

  Future<CustModel> getCustomers(String customerId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("customers")
        .doc(customerId)
        .get();

    Map<String, dynamic> customerData = snapshot.data()!;
    return CustModel.fromMap(customerData);
  }
@override
  Widget build(BuildContext context) {
    if (widget.number == 1) {
      //customer
      return buildFirstScreen(context);
    } else {
      //owner
      return buildSecondScreen(context);
    }
  }
Widget buildFirstScreen(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("الرسائل"),
        backgroundColor: primaryRed,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        currentIndex: 1,
                      )),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: primaryGrey,
          child: FutureBuilder<CustModel>(
            future: customerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                CustModel customer = snapshot.data!;
                print('custId: ${customer.custId}'); // Debug line
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .snapshots(),
                  builder: (context, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (chatSnapshot.hasError) {
                      return Center(
                        child: Text(chatSnapshot.error.toString()),
                      );
                    } else {
                      QuerySnapshot<Map<String, dynamic>> chatRoomSnapshot =
                          chatSnapshot.data!;

                      if (chatRoomSnapshot.docs.isEmpty) {
                        return Center(
                          child: Text("No chats"),
                        );
                      }
                      return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomSnapshot.docs[index].data(),
                          );

                          //if the customer is a participant in the chatroom
                          if (chatRoomModel.participants != null && chatRoomModel.participants![customer.custId.toString()] == true) {

                            // Fetch the ownerId from the participants map
                            String ownerId =
                                chatRoomModel.participants!.keys.firstWhere(
                              (key) => key != customer.custId.toString(),
                            );

                            Future<OwnerModel> ownerFuture =
                                getOwners(ownerId);

                            return FutureBuilder<OwnerModel>(
                              future: ownerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  OwnerModel targetUser = snapshot.data!;

                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatRoomScreen(
                                              chatroom: chatRoomModel,
                                              customer: customer,
                                              owner: targetUser,
                                              number:1
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    title: Text(
                                      targetUser.fullname.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                            fontSize: 20,

                                      ),
                                    ),
                                     leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/icons/user.png"),
                                ),
                                    subtitle:
                                        (chatRoomModel.lastMessage.toString() !=
                                                "")
                                            ? Text(chatRoomModel.lastMessage
                                                .toString())
                                            : Text(
                                                "....",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                  );
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("No customer data available"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
 Widget buildSecondScreen(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("الرسائل"),
        backgroundColor: primaryRed,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OwnerScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: primaryGrey,
          child: FutureBuilder<OwnerModel>(
            future: ownerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                OwnerModel owner = snapshot.data!;
                // print('custId: ${customer.custId}'); // Debug line
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .snapshots(),
                  builder: (context, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (chatSnapshot.hasError) {
                      return Center(
                        child: Text(chatSnapshot.error.toString()),
                      );
                    } else {
                      QuerySnapshot<Map<String, dynamic>> chatRoomSnapshot =
                          chatSnapshot.data!;

                      if (chatRoomSnapshot.docs.isEmpty) {
                        return Center(
                          child: Text("No chats"),
                        );
                      }
                      return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomSnapshot.docs[index].data(),
                          );

                          //if the owner is a participant in the chatroom
                        if (chatRoomModel.participants != null && chatRoomModel.participants![owner.ownerId.toString()] == true) {

                            // Fetch the customersId from the participants map
                            String custId =
                                chatRoomModel.participants!.keys.firstWhere(
                              (key) => key != owner.ownerId.toString(),
                            );

                            Future<CustModel> customerFuture =
                                getCustomers(custId);

                            return FutureBuilder<CustModel>(
                              future: customerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  CustModel targetUser = snapshot.data!;

                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ChatRoomScreen(
                                              chatroom: chatRoomModel,
                                              customer: targetUser,
                                              owner: owner,
                                              number:0
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    title: Text(
                                      targetUser.fullname.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                            fontSize: 20,

                                      ),
                                    ),
                                     leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/icons/user.png"),
                                ),
                                    subtitle:
                                        (chatRoomModel.lastMessage.toString() !=
                                                "")
                                            ? Text(chatRoomModel.lastMessage
                                                .toString())
                                            : Text(
                                                "....",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                  );
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("No Owner data available"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
