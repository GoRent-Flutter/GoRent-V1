import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/ContactOwner/Chatting_System/chat_room_model.dart';
import 'package:gorent_application1/screens/ContactOwner/Chatting_System/user_models_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models_Folder/CustModel.dart';
import '../../Models_Folder/OwnerModel.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  ChatsScreenState createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  late Future<CustModel> customerFuture;
  helper user_models_helper = helper();

  @override
  void initState() {
    super.initState();
    customerFuture = getCustomerModel();
  }

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
  // print(CustModel.fromMap(custdata).fullname);
      return CustModel.fromMap(custdata);
    }
    throw Exception("Failed to fetch customer model");
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text("الرسائل"),
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
              // print("kkkk" + customer.fullname.toString());
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .where("participants", arrayContains: customer.custId)
                    .snapshots(),
                builder: (context, chatRoomSnapshot) {
                  if (chatRoomSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (chatRoomSnapshot.hasError) {
                    return Center(
                      child: Text(chatRoomSnapshot.error.toString()),
                    );
                  } else if (chatRoomSnapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>> chatRoomDataSnapshot =
                        chatRoomSnapshot.data!;
                    print(
                        'Count: ${chatRoomDataSnapshot.docs.length}');
                    return ListView.builder(
                      itemCount: chatRoomDataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomDataSnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        return ListTile(
                          subtitle: Text(chatRoomModel.lastMessage ?? ""),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("No chats"),
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

}
