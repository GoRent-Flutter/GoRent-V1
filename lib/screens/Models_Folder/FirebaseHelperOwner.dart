//this will be used to help in fetching owner data to the app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorent_application1/screens/Models_Folder/OwnerModel.dart';

class FirebaseHelperOwner {
  Future<OwnerModel?> getModelById(String id) async {
    OwnerModel? ownerModel;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("owners").doc(id).get();
    if (documentSnapshot.data() != null) {
      ownerModel =
          OwnerModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return ownerModel;
  }
}
