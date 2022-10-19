import 'package:badges/badges.dart';
import 'package:ecommerce/core/theme/colors.dart';
import 'package:ecommerce/core/utils/dimesions.dart';
import 'package:ecommerce/pages/cart/controllers/cart_controller.dart';
import 'package:ecommerce/pages/cart/ui/index.dart';
import 'package:ecommerce/pages/home/ui/widgets/banners.dart';
import 'package:ecommerce/pages/home/ui/widgets/categories.dart';
import 'package:ecommerce/pages/home/ui/widgets/my_text.dart';
import 'package:ecommerce/pages/home/ui/widgets/recent_products.dart';
import 'package:ecommerce/pages/home/ui/widgets/search_box.dart';
import 'package:ecommerce/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
  final CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: const MyText(
                      text: 'Delivery address',
                      color: AppColors.text2Color,
                    ),
                  ),
                  const MyText(
                    text: 'Salatiga City, Central Java',
                    weight: FontWeight.w500,
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [



                  // IconButton(
                  //   padding: EdgeInsets.zero,
                  //   constraints: const BoxConstraints(),
                  //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage())),
                  //   icon: Badge(
                  //     child: SvgPicture.asset('assets/icons/Buy.svg'),
                  //   ),
                  //   iconSize: Dimensions.iconSize26,
                  // ),
                  // SizedBox(
                  //   width: Dimensions.width15,
                  // ),

                  IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> CartPage())),
                      icon: SvgPicture.asset('assets/icons/Buy.svg', ),
                    iconSize: Dimensions.iconSize26,
                    padding: EdgeInsets.only(top:22, right: 10),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: ()async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset('assets/icons/logout.svg'),
                    iconSize: 22,
                  )
                  //Notification
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.search),
            child: SearchBox(
              isEnabled: false,
            ),
          ),
          Banners(),
          const Categories(),
          RecentProduct(),
        ],
      ),
    );
  }
}

/*
IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: SvgPicture.asset('assets/icons/Notification.svg'),
                    iconSize: Dimensions.iconSize26,
                  )
*/