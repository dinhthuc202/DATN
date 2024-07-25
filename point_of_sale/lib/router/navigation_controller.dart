import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';
import '../page/home_page.dart';
import '../page/item/edit_item_page.dart';
import '../page/item/item_page.dart';
import '../page/item/new_item_page.dart';
import '../page/login_page.dart';
import '../page/partner/edit_partner_page.dart';
import '../page/partner/new_partner_page.dart';
import '../page/partner/partner_page.dart';
import '../page/purchase/purchase_history.dart';
import '../page/purchase/purchase_page.dart';
import '../page/sale/sale_history.dart';
import '../page/sale/sale_page.dart';
import '../page/user/new_user_page.dart';
import '../page/user/user_page.dart';
import 'router.dart';

class NavigationController extends GetxController {
  static NavigationController instance = Get.find();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  goBack() => navigatorKey.currentState?.pop();
  Rx<ScreenActive> screenActive = homePage.obs;

  changeScreen(ScreenActive value) {
    screenActive.value = value;
  }

  Widget showScreenActive() {
    switch (screenActive.value.router) {
      case "/":
        return const HomePage();
      case "/home":
        return const HomePage();
      case "/login":
        return const LoginPage();
      case "/sale":
        return const SalePage();
      case "/saleHistory":
        return const SaleHistory();
      case "/purchase":
        return const PurchasePage();
      case "/purchaseHistory":
        return const PurchaseHistory();
      case "/partner":
        return const PartnerPage();
      case "/newPartner":
        return const NewPartnerPage();
      case "/editPartner":
        return const EditPartnerPage();
      case "/item":
        return const ItemPage();
      case "/newItem":
        return const NewItemPage();
      case "/editItem":
        return const EditItemPage();
      case "/users":
        return const UserPage();
        case "/newUser":
        return const NewUserPage();
      default:
        return const HomePage();
    }
  }
}
