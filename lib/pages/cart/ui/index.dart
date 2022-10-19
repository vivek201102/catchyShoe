import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/theme/colors.dart';
import 'package:ecommerce/pages/detail/ui/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ecommerce/core/utils/dimesions.dart';
import 'package:ecommerce/pages/cart/controllers/cart_controller.dart';
import 'package:ecommerce/pages/home/ui/widgets/my_text.dart';


class CartPage extends GetView<CartController> {




  var _reference = FirebaseFirestore.instance.collection('cartData').where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid);
  late Stream<QuerySnapshot> _stream =_reference.snapshots();
  int change = 0;
  var ids = [];


  @override
  Widget build(BuildContext context)
  {



    return Scaffold(
      appBar:AppBar(
        title: Text("Cart",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Cart Items',
                size: Dimensions.font16,
                weight: FontWeight.w500,
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/Filter.svg',
                  height: Dimensions.height20,
                  width: Dimensions.width20,
                ),
              )
            ],
          ),

          SizedBox(
            height: Dimensions.height10,
          ),

          StreamBuilder<QuerySnapshot>(

            stream: _stream,

            builder: (BuildContext contex, AsyncSnapshot snapshot){

              if (snapshot.hasError) {

                return Center(child: Text('Some error occurred ${snapshot.error}'));

              }

              if(snapshot.hasData){

                QuerySnapshot querySnapshot = snapshot.data;

                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                documents.forEach((element) {
                  ids.add(element.id);
                });



                List<Map> items = documents.map((e) => e.data() as Map).toList();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: Dimensions.bannerHeight,
                  ),
                  itemBuilder: (BuildContext context, int index) {

                    return ShoeCard(shoe: items[index], id: ids[index]);
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),

          Padding(padding: EdgeInsets.only(top:90, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(),
                  child: ElevatedButton(
                      onPressed: (){

                      },
                      child: Text("Proceed to Payment"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.main),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 15, vertical: 20))
                      )
                  ),
                )
              ],
            ),
          )
        ],
      ),
      ),

    );
  }
}


class ShoeCard extends StatefulWidget {
  const ShoeCard({Key? key,required this.shoe, required this.id}) : super(key: key);

  final Map shoe;
  final id;


  @override
  State<ShoeCard> createState() => _ShoeCardState(this.shoe, this.id);
}

class _ShoeCardState extends State<ShoeCard> {


  _ShoeCardState(this.shoe, this.id);


  @override

  final Map shoe;
  final String id;
  int qty = 0;

  Future addQty() async{

    await FirebaseFirestore.instance.collection("cartData").doc(id).update({'qty': shoe['qty'] + 1 });
    setState(() {
      qty = qty + 1;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPage()));
  }

  Future decQty() async{
    if(qty == 1)
    {
      await FirebaseFirestore.instance.collection("cartData").doc(id).delete();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPage()));
    }
    else{
      await FirebaseFirestore.instance.collection("cartData").doc(id).update({'qty': shoe['qty'] - 1 });
      setState(() {
        qty = qty - 1;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPage()));
    }
  }

  @override
  Widget build(BuildContext context) {

    if(qty == 0)
    {
      setState(() {
        qty = shoe['qty'];
      });
    }
    return Padding(padding: EdgeInsets.only(top: 10),
      child:
      Container(
        width: MediaQuery. of(context). size. width,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 100,
                child: Image.network(shoe['imageUrl'], fit: BoxFit.cover,),
              ),

              Column(
                children: [
                  Padding(padding: EdgeInsets.only(top:40, left: 20),
                    child: Text(shoe['name']),
                  ),
                  Padding(padding: EdgeInsets.only(top:40, left: 20),
                    child: Text("Rs:" + shoe['price'].toString()),
                  )
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top:65, left:40),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: () async{
                      await decQty();
                    }, icon: Icon(Icons.remove)),
                    Text(qty.toString()),
                    IconButton(onPressed: ()async{
                      await addQty();
                    }, icon: Icon(Icons.add)),
                  ] ,
                ),
              ),
            ]
        ),
      ),
    );
  }

}