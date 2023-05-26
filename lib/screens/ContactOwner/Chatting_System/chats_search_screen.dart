import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Models_Folder/CustModel.dart';
import 'package:gorent_application1/screens/Models_Folder/OwnerModel.dart';

import '../../../constraints.dart';
import 'chat_room_screen.dart';

class ChatsSearchScreen extends StatefulWidget {
  const ChatsSearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<ChatsSearchScreen> {
  TextEditingController searchController = TextEditingController();
  String id = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("البحث"),
        backgroundColor: primaryRed,
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: primaryGrey,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(labelText: "البريد الإلكتروني"),
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                setState(() {});
              },
              color: primaryRed,
              child: Text("بحث"),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("customers")
                  .where("email", isEqualTo: searchController.text)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapShot = snapshot.data as QuerySnapshot;
                    if (dataSnapShot.docs.isNotEmpty) {
                      // Check if docs is not empty
                      Map<String, dynamic> userMap =
                          dataSnapShot.docs[0].data() as Map<String, dynamic>;
                      CustModel searchedCustomer = CustModel.fromMap(userMap);
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                           Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ChatRoomScreen();}));
                        },
                        leading: CircleAvatar(
                          backgroundColor: primaryLine,
                        ),
                        title: Text(searchedCustomer.fullname!),
                        subtitle: Text(searchedCustomer.email!),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      );
                    } else {
                      return Text("No results found");
                    }
                  } else if (snapshot.hasError) {
                    return Text("An error occurred");
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      )),
    );
  }
}
