import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/DatabaseManager/UserManager.dart';

class AuthUser{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createUser(String email, String pass, String mobile, String name) async
  {
    try{
      print("In add");
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      await UserManage().createUserData(name, mobile, user?.uid);
      return user;
    }
    catch(e){
      print(e.toString());
    }
  }

  Future authUser(String email, String pass) async
  {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return result.user;
    }
    catch(e)
    {
      print(e.toString());
    }
  }

}