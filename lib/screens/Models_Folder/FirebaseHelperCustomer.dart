//this will be used to help in fetching customer data to the app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorent_application1/screens/Models_Folder/CustModel.dart';

class FirebaseHelperCustomer {
  Future<CustModel?> getModelById(String id) async {
    CustModel? custModel;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("customers").doc(id).get();
    if (documentSnapshot.data() != null) {
      custModel =
          CustModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return custModel;
  }
}
