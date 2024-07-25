import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'controller/size_controller.dart';
import 'controller/user_controller.dart';
import 'router/navigation_controller.dart';
import 'router/responsive_layout.dart';
import 'router/router.dart';

void main() async {
  await GetStorage.init();
  Get.put(NavigationController());
  Get.put(SizeController());
  var userController = Get.put(UserController());
  await userController.checkLogin();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    sizeController.getSize(context);
    return GetMaterialApp(
      initialRoute: homePage.router,
      getPages: [
        GetPage(
          name: '/',
          page: () {
            navigationController.changeScreen(homePage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/home',
          page: () {
            navigationController.changeScreen(homePage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/sale',
          page: () {
            navigationController.changeScreen(salePage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: saleHistoryPage.router,
          page: () {
            navigationController.changeScreen(saleHistoryPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/login',
          page: () {
            navigationController.changeScreen(authPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/purchase',
          page: () {
            navigationController.changeScreen(purchasePage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: purchaseHistoryPage.router,
          page: () {
            navigationController.changeScreen(purchaseHistoryPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/partner',
          page: () {
            navigationController.changeScreen(partnerPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/newPartner',
          page: () {
            navigationController.changeScreen(newPartnerPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: editPartnerPage.router,
          page: () {
            navigationController.changeScreen(editPartnerPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/item',
          page: () {
            navigationController.changeScreen(itemPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: '/newItem',
          page: () {
            navigationController.changeScreen(newItemPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: editItemPage.router,
          page: () {
            navigationController.changeScreen(editItemPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: userPage.router,
          page: () {
            navigationController.changeScreen(userPage);
            return const ResponsiveLayout();
          },
        ),
        GetPage(
          name: newUserPage.router,
          page: () {
            navigationController.changeScreen(newUserPage);
            return const ResponsiveLayout();
          },
        ),
      ],
      debugShowCheckedModeBanner: false,
      title: 'PosApp',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: textColor),
        primarySwatch: Colors.blue,
      ),
    );
  }
}
