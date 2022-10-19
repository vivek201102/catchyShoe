import 'package:flutter/material.dart';
import 'package:ecommerce/pages/components/background.dart';
import 'package:ecommerce/responsive.dart';
import 'components/login_signup_btn.dart';
import 'components/welcome_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/pages/main/ui/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/pages/Seller/UploadProduct/addProduct.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);



  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    Future checkAuthedUser() async{
      if(await FirebaseAuth.instance.currentUser?.uid != null)
      {
        print("sign in");
        await FirebaseFirestore.instance.collection("Buyer").doc(await FirebaseAuth.instance.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot){
          if(documentSnapshot.exists)
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Main()));
          }
        });
        await FirebaseFirestore.instance.collection("Seller").doc(await FirebaseAuth.instance.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot){
          if(documentSnapshot.exists)
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));
          }
        });

      }
      else{

        return;
      }
    }

    checkAuthedUser();

    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(
                  child: WelcomeImage(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 450,
                        child: LoginAndSignupBtn(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: const MobileWelcomeScreen(),
          ),
        ),
      ),
    );
  }
}


class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const WelcomeImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginAndSignupBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}