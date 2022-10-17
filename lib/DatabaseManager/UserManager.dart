import 'package:cloud_firestore/cloud_firestore.dart';
class UserManage{
  final CollectionReference userdata = FirebaseFirestore.instance.collection("User");

  Future<void> createUserData(String name, String mobile, String? uid) async{
    return await userdata.doc(uid).set({
      "name" : name,
      "mobile" : mobile,
    });
}
}