import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/theme/colors.dart';
import 'package:ecommerce/core/utils/dimesions.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/network/models/shoe.dart';
import 'package:ecommerce/pages/cart/controllers/cart_controller.dart';
import 'package:ecommerce/pages/detail/ui/index.dart';
import 'package:ecommerce/pages/home/data/shoes.dart';
import 'package:ecommerce/pages/home/ui/widgets/my_text.dart';
import 'package:ecommerce/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RecentProduct extends StatefulWidget {
  // const RecentProduct({Key? key}) : super(key: key);
  var _reference = FirebaseFirestore.instance.collection('productData');
  late Stream<QuerySnapshot> _stream =_reference.snapshots();  @override
  State<RecentProduct> createState() => _RecentProductState();
}

class _RecentProductState extends State<RecentProduct> {


  @override
  Widget build(BuildContext context) {
    return Column(
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
            stream: widget._stream,
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
    );
  }
}






class ShoeCard extends StatelessWidget {
  const ShoeCard({
    Key? key,
    required this.shoe,
  }) : super(key: key);

  final Map shoe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        DetailsPage(shoe: shoe),
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
                  onPressed: (){},
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
