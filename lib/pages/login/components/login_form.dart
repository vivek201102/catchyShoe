import 'package:flutter/material.dart';

import 'package:ecommerce/pages/components/already_have_an_account_acheck.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ecommerce/Services/AuthServices.dart';
import 'package:ecommerce/pages/main/ui/index.dart';

import 'package:ecommerce/pages/Seller/UploadProduct/addProduct.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool loading = false;
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int userType = 1;


  void checkUser(context) async {
    String email = emailController.text;
    String pass = passwordController.text;

    var user = await AuthUser().authUser(email, pass, userType);

    if (user == null) {
      Fluttertoast.showToast(msg: "Invalid Email or Password");
      passwordController.text = "";
      // passwordController.clear();
      print("Invalid user");
      return;
    }
    else {
      if (userType == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Main()));
      }
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AddProduct()));
      }
    }
  }


  @override
  Widget build(BuildContext context) {



    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(

        child: Form(
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                controller: emailController,
                focusNode: focusEmail,
                onSaved: (email) {},
                decoration: InputDecoration(
                  hintText: "Your email",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  controller: passwordController,
                  focusNode: focusPassword,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "Your password",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio   (value: 1, groupValue: userType, onChanged: (value){
                    setState(() {
                      userType = 1;
                    });

                  },
                  ),
                  Text("Buyer"),

                  Radio(
                    value: 2, groupValue: userType, onChanged: (value){
                    setState(() {
                      userType = 2;

                    });

                  },
                  ),
                  Text("Seller")

                ],
              ),
              const SizedBox(height: 50),
              Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  onPressed: () {
                    checkUser(context);
                  },
                  child: Text(
                    "Login".toUpperCase(),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        )
    )
    );

  }
}

