import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/DatabaseManager/UserManager.dart';

class AuthUser{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createUser(String email, String pass, String mobile, String name, String userType) async
  {
    try{
      print("In add");

      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      if(userType == "buyer")
      {
          await UserManage().createBuyerData(name, mobile, user?.uid);
      }
      else{
          await UserManage().createSellerData(name, mobile, user?.uid);
      }
      return user;
    }
    catch(e){
      print(e.toString());
    }
  }

  Future authUser(String email, String pass, int userType) async
  {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if(result.user == null)
        {
          return null;
        }

      else{
        if(userType == 1)
          {
            if(await UserManage().checkBuyer(result.user?.uid) == true)
            {
                return result.user;
            }
            else{
              return null;
            }
          }
        else{
            if(await UserManage().checkSeller(result.user?.uid) == true){
              return result.user;
            }
            else{
              return null;
            }
        }
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }

}