import 'package:ecommerce/pages/home/ui/index.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/pages/components/already_have_an_account_acheck.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/pages/login/login_screen.dart';
import 'package:ecommerce/Services/AuthServices.dart';
import 'package:ecommerce/pages/home/ui/index.dart';
import 'package:get/get.dart';
import 'package:ecommerce/routes/routes.dart';
import 'package:ecommerce/pages/main/ui/index.dart';

class SignUpForm extends StatelessWidget {

  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();
  final FocusNode focusName = FocusNode();
  final FocusNode focusMobile = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  SignUpForm({
    Key? key,
  }) : super(key: key);



  void addUser() async{
    String name = nameController.text;
    String mobile = mobileController.text;
    String password = passwordController.text;
    String email = emailController.text;
    await AuthUser().createUser(email, password, mobile, password);

  }

  @override
  Widget build(BuildContext context) {

    return Form(
      child: Column(
        children: [

          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: nameController,
            focusNode: focusName,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),

          const SizedBox(height: defaultPadding / 2),


          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: mobileController,
            focusNode: focusMobile,
            decoration: InputDecoration(
              hintText: "Mobile No",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.call),
              ),
            ),
          ),

          const SizedBox(height: defaultPadding / 2),

          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: emailController,
            focusNode: focusEmail,

            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              focusNode: focusPassword,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              //add user function
              addUser();
              // Get.put(HomePage());
              // Get.toNamed(Routes.cart);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
            },
            
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}