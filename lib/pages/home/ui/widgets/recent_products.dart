import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/theme/colors.dart';
import 'package:ecommerce/core/utils/dimesions.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/pages/detail/ui/index.dart';
import 'package:ecommerce/pages/home/ui/widgets/my_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RecentProduct extends StatefulWidget {
  // const RecentProduct({Key? key}) : super(key: key);
  var _reference = FirebaseFirestore.instance.collection('productData');
  late Stream<QuerySnapshot> _stream =_reference.snapshots();
  var idList = [];
  @override
  State<RecentProduct> createState() => _RecentProductState();
}

class _RecentProductState extends State<RecentProduct> {

  void printMethod(){
    print("In Print Method priting the p");
  }



  @override
  Widget build(BuildContext context) {
    printMethod();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Products',
              size: Dimensions.font16,
              weight: FontWeight.w500,
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/Filter.svg',
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
            stream: widget._stream,
            builder: (BuildContext contex, AsyncSnapshot snapshot){
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred ${snapshot.error}'));
              }
              if(snapshot.hasData){
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                documents.forEach((element) {
                  widget.idList.add(element.id);
                });
                List<Map> items = documents.map((e) => e.data() as Map).toList();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: Dimensions.cardHeight,
                  ),
                  itemBuilder: (BuildContext context, int index) {


                    return ShoeCard(shoe: items[index], id: widget.idList[index]);
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
        )
      ],
    );
  }
}




class ShoeCard extends StatefulWidget {
  const ShoeCard({Key? key, required this.id,required this.shoe}) : super(key: key);
  final String id;
  final Map shoe;
  @override
  State<ShoeCard> createState() => _ShoeCardState(this.id, this.shoe);
}

class _ShoeCardState extends State<ShoeCard> {
  CartModel cm = CartModel();
  CollectionReference _reference = FirebaseFirestore.instance.collection('cartData');
  _ShoeCardState(this.id, this.shoe);


  final String id;
  final Map shoe;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        DetailsPage(shoe: shoe, id: id),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius8),
            topRight: Radius.circular(Dimensions.radius8),
          ),
        ),
        elevation: .5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius8),
                topRight: Radius.circular(Dimensions.radius8),
              ),
              child: Image.network(
                shoe['imageUrl'],
                height: Dimensions.coverHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.width15, top: Dimensions.height10),
              child: MyText(
                text: shoe['name'],
                size: 14,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.width15,
                top: Dimensions.height5,
                bottom: Dimensions.height15,
              ),
              child: MyText(
                text: '\Rs ${shoe['price'].toStringAsFixed(2)}',
                size: 15,
                weight: FontWeight.w500,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                width: double.infinity,
                height: Dimensions.height45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.main),

                  ),
                  onPressed: () async{
                    cm.uid = await FirebaseAuth.instance.currentUser?.uid;
                    final snap = await FirebaseFirestore.instance.collection("cartData").where('uid', isEqualTo: cm.uid).where('pid', isEqualTo: id).get();
                    if(snap.docs.length == 0)
                      {
                        cm.name = shoe['name'];
                        cm.price = shoe['price'];
                        cm.qty = 1;
                        cm.pid = id;
                        cm.imageUrl = shoe['imageUrl'];

                        Map<String, dynamic> cartData = cm.toMap();
                        _reference.add(cartData);
                        Fluttertoast.showToast(msg: "Product added sucessfully");
                      }
                    else{
                        Fluttertoast.showToast(msg: "Product already in cart");
                    }

                  },
                  // onPressed: () => Get.find<CartController>().addToCart(shoe),
                  child: const Text(
                    'Add to cart',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

