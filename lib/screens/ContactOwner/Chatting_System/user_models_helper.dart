import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models_Folder/CustModel.dart';
import '../../Models_Folder/OwnerModel.dart';

class helper{
    late CustModel customer;
  late OwnerModel owner;
  late String id;
  Future<void> getUsersModels(String passedOwnerId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    List<String> parts = sessionId!.split('.');
    id = parts[1].toString() + '.' + parts[2].toString();
    //get customer model
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("customers")
        .where("custId", isEqualTo: id.toString())
        .get();

    if (snapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          snapshot.docs[0];

      Map<String, dynamic> custdata = documentSnapshot.data();

      customer = CustModel.fromMap(custdata);
    }
    //get owner model
    QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore
        .instance
        .collection("owners")
        .where("ownerId", isEqualTo: passedOwnerId.toString())
        .get();

    if (snapshot2.docs.isNotEmpty) {
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot2 =
          snapshot2.docs[0];
      Map<String, dynamic> ownerdata = documentSnapshot2.data();

      owner = OwnerModel.fromMap(ownerdata);
    }
  }
}