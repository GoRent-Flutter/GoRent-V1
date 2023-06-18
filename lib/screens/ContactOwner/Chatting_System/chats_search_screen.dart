import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/ContactOwner/Chatting_System/chat_room_model.dart';
import 'package:gorent_application1/screens/Models_Folder/CustModel.dart';
import 'package:gorent_application1/screens/Models_Folder/OwnerModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../constraints.dart';
import 'chat_room_screen.dart';

class ChatsSearchScreen extends StatefulWidget {
  final OwnerModel ownerModel;
  const ChatsSearchScreen({Key? key, required this.ownerModel}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<ChatsSearchScreen> {
  TextEditingController searchController = TextEditingController();
  String id = "";
  Future<ChatRoomModel?> getChatRoomModel(OwnerModel targetOwner, OwnerModel currentOwner) async{
    ChatRoomModel? chatRoom;
  final prefs = await SharedPreferences.getInstance();
  final sessionId = prefs.getString('sessionId');
  if (sessionId != null) {
    List<String> parts = sessionId.split('.');
    id=parts[1].toString();
  }
    QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("chatRooms").where("participants.${currentOwner.ownerId}",isEqualTo: true).where("participants.${targetOwner.ownerId}",isEqualTo: true).get();
   if (snapshot.docs.length>0){
    var docData=snapshot.docs[0].data();
    ChatRoomModel existingChatRoom=ChatRoomModel.fromMap(docData as Map<String,dynamic>);
    chatRoom=existingChatRoom;
   }
   else{
    String chatRoomRandomId=Uuid().v4();
    ChatRoomModel newChatRoom=ChatRoomModel(
      chatRoomId:chatRoomRandomId,
      lastMessage:"",
      participants:{ currentOwner.ownerId.toString():true,targetOwner.ownerId.toString():true,});
await FirebaseFirestore.instance.collection("chatRooms").doc(newChatRoom.chatRoomId).set(newChatRoom.toMap());
chatRoom=newChatRoom;
   }
   return chatRoom;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البحث"),
        backgroundColor: primaryRed,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: primaryGrey,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                setState(() {});
              },
              color: primaryRed,
              child: const Text("بحث"),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("owners")
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
                      OwnerModel searchedOwner = OwnerModel.fromMap(userMap);
                      // OwnerModel currentOwner=OwnerModel.fromMap(id);
                      return ListTile(
                        onTap: () async{
                          //wrong here 
                          ChatRoomModel? chatRoomModel=await getChatRoomModel(searchedOwner,searchedOwner);
                          if(chatRoomModel!=null){
                               Navigator.pop(context);
                           Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ChatRoomScreen(
                                    targetOwner: searchedOwner,
                                    chatroom:chatRoomModel ,
                                  );}));
                          }
                       
                        },
                        leading: const CircleAvatar(
                          backgroundColor: primaryLine,
                        ),
                        title: Text(searchedOwner.fullname!),
                        subtitle: Text(searchedOwner.email!),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      );
                    } else {
                      return const Text("No results found");
                    }
                  } else if (snapshot.hasError) {
                    return const Text("An error occurred");
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      )),
    );
  }
}
