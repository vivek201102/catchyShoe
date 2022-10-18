import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/theme/colors.dart';
import 'package:ecommerce/pages/detail/ui/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:ecommerce/core/utils/dimesions.dart';
import 'package:ecommerce/network/models/cart_item.dart';
import 'package:ecommerce/pages/cart/controllers/cart_controller.dart';
import 'package:ecommerce/pages/home/ui/widgets/my_text.dart';
import 'package:ecommerce/routes/routes.dart';

class CartPage extends GetView<CartController> {




  var _reference = FirebaseFirestore.instance.collection('cartData').where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid);
  late Stream<QuerySnapshot> _stream =_reference.snapshots();




  @override
  Widget build(BuildContext context)
  {



    return Scaffold(
      body:
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Recent Products',
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
          stream: _stream,
          builder: (BuildContext contex, AsyncSnapshot snapshot){
            if (snapshot.hasError) {
              return Center(child: Text('Some error occurred ${snapshot.error}'));
            }
            if(snapshot.hasData){
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

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


                  return ShoeCard(shoe: items[index]);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        )
      ],
    ),

    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.height20,
                  vertical: Dimensions.height20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        SizedBox(
                          width: Dimensions.width30,
                        ),
                        MyText(
                          text: 'Your Cart',
                          size: Dimensions.font20,
                          weight: FontWeight.w500,
                        )
                      ],
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Get.toNamed(Routes.cart),
                      icon: Badge(
                        badgeContent: Obx(
                          () => MyText(
                            text: Get.find<CartController>()
                                .items
                                .length
                                .toString(),
                            color: Colors.white,
                          ),
                        ),
                        child: SvgPicture.asset('assets/icons/Buy.svg'),
                      ),
                      iconSize: Dimensions.iconSize26,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1.1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.height20,
                  vertical: Dimensions.height10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MyText(
                      text: 'Delivery to',
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: 'Salatiga City, Central Java',
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1.1,
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

                    List<Map> items = documents.map((e) => e.data() as Map).toList();
                    return GetBuilder<CartController>(
                      builder: (_) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.items.length,
                          itemBuilder: (_, index) {
                            return CartItemView(
                              item: items[index],
                            );
                          },
                        );
                      },
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                },
              )



              // GetBuilder<CartController>(
              //   builder: (_) {
              //     return ListView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemCount: controller.items.length,
              //       itemBuilder: (_, index) {
              //         return CartItemView(
              //           item: controller.items[index],
              //         );
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 20,
        child: Container(
          padding: EdgeInsets.only(
            top: Dimensions.height20,
            left: Dimensions.height20,
            right: Dimensions.height20,
          ),
          height: Dimensions.height100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: 'Totals',
                    size: Dimensions.font16,
                  ),
                  Obx(
                    () => MyText(
                      text: '\$ ${controller.total.toStringAsFixed(2)}',
                      size: Dimensions.font16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                width: double.infinity,
                height: Dimensions.height40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.main),
                  ),
                  onPressed: () =>
                      Get.snackbar('Omm...', 'Server not Responding!'),
                  child: const Text(
                    'Continur for payments',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemView extends StatelessWidget {
  const CartItemView({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Map item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Get.to(
      //   // DetailsPage(shoe: item),
      // ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius8),
              child: Image.network(
                item['imageUrl'],
                height: Dimensions.height100,
                width: Dimensions.width100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: Dimensions.width10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height5,
              ),
              height: Dimensions.height100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: item['name'],
                    size: 17,
                  ),
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: '\$${item['price'].toStringAsFixed(2)}',
                          size: 17,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: (){},
                              // onPressed: () =>
                                  // Get.find<CartController>().addQuantity(item),

                              icon: const Icon(Icons.add),
                            ),
                            MyText(text: item['qty'].toString()),
                            IconButton(
                              onPressed: () {},
                                  // Get.find<CartController>().lowQuantity(item),
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }

   */
}



class ShoeCard extends StatefulWidget {
  const ShoeCard({Key? key,required this.shoe}) : super(key: key);

  final Map shoe;
  @override
  State<ShoeCard> createState() => _ShoeCardState(this.shoe);
}

class _ShoeCardState extends State<ShoeCard> {
  CollectionReference _reference = FirebaseFirestore.instance.collection('cartData');
  _ShoeCardState(this.shoe);



  final Map shoe;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(

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
                text: '\Rs${shoe['price'].toStringAsFixed(2)}',
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
                  onPressed: (){

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
