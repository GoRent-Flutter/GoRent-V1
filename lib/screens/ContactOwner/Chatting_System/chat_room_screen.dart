import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryRed
        ),
        body: SafeArea(
          child: Container(
            color: primaryGrey,
            child: Column(children: [
              Expanded(child: Container()),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 209, 206, 206),
                  borderRadius:
                      BorderRadius.circular(30.0), // Set the border radius
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                child: Row(children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.send, color: Colors.black)),
                  Flexible(
                    child: TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "...أرسل رسالة")),
                  ),
                ]),
              )
            ]),
          ),
        ));
  }
}
