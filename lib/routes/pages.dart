import 'package:ecommerce/pages/cart/bindings/cart_binding.dart';
import 'package:ecommerce/pages/cart/ui/index.dart';
import 'package:ecommerce/pages/detail/ui/index.dart';
import 'package:ecommerce/pages/home/ui/index.dart';
import 'package:ecommerce/pages/home/ui/widgets/search_box.dart';
import 'package:ecommerce/pages/main/bindings/main_bindings.dart';
import 'package:ecommerce/pages/main/ui/index.dart';
import 'package:ecommerce/pages/search/bindings/search_binding.dart';
import 'package:ecommerce/pages/search/ui/index.dart';
import 'package:ecommerce/routes/routes.dart';
import 'package:get/get.dart';
import 'package:ecommerce/pages/welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pages {
  String? uid;
  Future getUId() async{
    return await FirebaseAuth.instance.currentUser?.uid;
  }

  static final List<GetPage<dynamic>> pages = [
    GetPage<WelcomeScreen>(
      name: Routes.initial,
      page: () => const WelcomeScreen(),
      binding: MainBindings(),
      transition: Transition.fadeIn,
      preventDuplicates: true,
    ),



    GetPage<HomePage>(
      name: Routes.home,
      page: () => HomePage(),
      transition: Transition.fadeIn,
      preventDuplicates: true,
    ),

    GetPage<SearchPage>(
      name: Routes.search,
      page: () => const SearchPage(),
      binding: SearchBinding(),
      transition: Transition.downToUp,
      preventDuplicates: true,
    ),

    GetPage<CartPage>(
      name: Routes.cart,
      page: () =>  CartPage(),
      binding: CartBindings(),
      transition: Transition.upToDown,
      preventDuplicates: true,
    ),
  ];
}
