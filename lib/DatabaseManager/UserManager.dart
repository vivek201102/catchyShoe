import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class UserManage{
  final CollectionReference buyerdata = FirebaseFirestore.instance.collection("Buyer");
  final CollectionReference sellerdata = FirebaseFirestore.instance.collection("Seller");

  Future<void> createBuyerData(String name, String mobile, String? uid) async{
    return await buyerdata.doc(uid).set({
      "name" : name,
      "mobile" : mobile,
    });
  }

  Future<void> createSellerData(String name, String mobile, String? uid) async{
    return await sellerdata.doc(uid).set({
      "name" : name,
      "mobile" : mobile,
    });
  }

  Future<bool> checkBuyer(String? uid) async
  {
    bool exist = false;
    await buyerdata.doc(uid).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists)
        {
          exist = true;
        }
    });

    return exist;
  }

  Future<bool> checkSeller(String? uid) async
  {

    bool exist = false;
    await sellerdata.doc(uid).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists)
      {
        exist = true;
      }
    });
    return exist;
  }


}