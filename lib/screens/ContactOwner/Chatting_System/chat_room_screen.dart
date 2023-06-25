import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/ContactOwner/Chatting_System/message_model.dart';
import 'package:gorent_application1/screens/Models_Folder/CustModel.dart';
import 'package:uuid/uuid.dart';
import '../../Models_Folder/OwnerModel.dart';
import 'chat_room_model.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoomModel chatroom;
  final CustModel customer;
  final OwnerModel owner;
  const ChatRoomScreen(
      {Key? key,
      required this.customer,
      required this.owner,
      required this.chatroom})
      : super(key: key);

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != "") {
      MessageModel newMessage = MessageModel(
          messageId: Uuid().v1(),
          sender: widget.customer.custId,
          createdOn: DateTime.now(),
          text: msg,
          seen: false);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomId)
          .set(widget.chatroom.toMap());
      print("message sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryRed,
          title: Row(
            children: [Text(widget.owner.fullname.toString())],
          ),
        ),
        body: SafeArea(
          child: Container(
            color: primaryGrey,
            child: Column(children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatRoomId)
                      .collection("messages")
                      .orderBy("createdOn", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.customer.custId)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: primaryPale,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(13),
                                          bottomLeft: Radius.circular(13),
                                          bottomRight: Radius.circular(13),
                                        ),
                                      ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ))
                                ]);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("check internet connection"),
                        );
                      } else {
                        return Center(
                          child: Text("say hello!!!!"),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
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
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(Icons.send, color: Colors.black)),
                  Flexible(
                    child: TextField(
                        controller: messageController,
                        textAlign: TextAlign.right,
                        maxLines: null,
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
