import 'dart:io';

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/pages/Seller/UploadProduct/imageUpload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/Utils/utils.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  ProductModel pm = ProductModel();
  CollectionReference _reference = FirebaseFirestore.instance.collection('productData');
  String imageUrl="";
  int category = 1;
  Uint8List? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize();
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Sell Product"),
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: [
              IconButton(onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              }, icon: Icon(Icons.logout))
            ],

          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          image == null
                              ? Image.asset(
                            "assets/icons/addImage.png",
                            height: screenSize.height / 10,
                          )
                              : Image.memory(
                            image!,
                            height: screenSize.height / 10,
                          ),
                          IconButton(
                              onPressed: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                print('${file?.path}');

                                if(file==null) return;
                                String uniqueFileName =  DateTime.now().millisecondsSinceEpoch.toString();
                                Reference referenceRoot = FirebaseStorage.instance.ref();
                                Reference referenceDirImages = referenceRoot.child('images');
                                Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
                                try {
                                  await referenceImageToUpload.putFile(File(file!.path));
                                  imageUrl = await referenceImageToUpload.getDownloadURL();
                                  print(imageUrl);
                                }catch(error){

                                }
                              },
                              icon: Icon(Icons.file_upload))
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 10),
                        height: screenSize.height * 0.4,
                        width: screenSize.width * 0.7,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(

                                controller: nameController,
                                obscureText: false,
                                decoration: InputDecoration(
                                hintText: "Enter the name of the item"),
                              onSaved: (value) {
                                  nameController.text = value!;
                              },
                                ),
                            TextFormField(

                                controller: costController,
                                obscureText: false,
                                decoration: InputDecoration(
                                hintText: "Enter the cost of the item"),
                              onSaved: (value) {
                                costController.text = value!;
                              },
                            ),
                            TextFormField(

                              controller: desController,
                              obscureText: false,
                              decoration: InputDecoration(
                                  hintText: "Enter Description of Product"),
                              onSaved: (value) {
                                desController.text = value!;
                              },
                            ),
                            TextFormField(

                              controller: quantityController,
                              obscureText: false,
                              decoration: InputDecoration(
                                  hintText: "Enter no of Product"),
                              onSaved: (value) {
                                quantityController.text = value!;
                              },
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Radio   (value: 1, groupValue: category, onChanged: (value){
                                  setState(() {
                                    category = 1;
                                  });

                                },
                                ),
                                Text("Men"),

                                Radio(
                                  value: 2, groupValue: category, onChanged: (value){
                                  setState(() {
                                    category = 2;

                                  });

                                },
                                ),
                                Text("Women"),



                              ],
                            ),

                          ],
                        ),
                      ),

                      Row(
                        children: [

                          Padding(
                              padding: EdgeInsets.only(left: 100),
                            child: ElevatedButton(
                              child: const Text(
                                    "Sell",
                                style: TextStyle(color: Colors.black),
                            ),
                                onPressed: () async {
                                  if(imageUrl!.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Upload an image')));
                                    return;
                                  }

                                  pm.name = nameController.text;
                                  pm.price = int.parse(costController.text);
                                  pm.qty = int.parse(quantityController.text);
                                  pm.des = desController.text;
                                  pm.imageUrl = imageUrl;
                                  pm.category = (category == 1)?"men":"women";
                                  Map<String, dynamic> productData = pm.toMap();
                                  _reference.add(productData);
                                  Fluttertoast.showToast(msg: "Product added sucessfully");
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));



                              }),
                          ),

                          Padding(padding: EdgeInsets.only(left: 20),
                            child:
                            ElevatedButton(
                                child: const Text(
                                  "Back",
                                  style: TextStyle(color: Colors.black),
                                ),

                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ));
  }
}