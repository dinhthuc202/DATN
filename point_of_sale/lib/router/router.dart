import 'package:flutter/material.dart';
import 'navigation_controller.dart';
import 'responsive_layout.dart';

ScreenActive homePage = ScreenActive(router: "/", pageDisplayName: "Home");
ScreenActive authPage =
    ScreenActive(router: "/login", pageDisplayName: "Login");
ScreenActive salePage =
    ScreenActive(router: "/sale", pageDisplayName: "Bán hàng");
ScreenActive saleHistoryPage =
    ScreenActive(router: "/saleHistory", pageDisplayName: "Lịch sử bán hàng");
ScreenActive purchasePage =
    ScreenActive(router: "/purchase", pageDisplayName: "Mua hàng");
ScreenActive purchaseHistoryPage = ScreenActive(
    router: "/purchaseHistory", pageDisplayName: "Lịch sử mua hàng");
ScreenActive partnerPage =
    ScreenActive(router: "/partner", pageDisplayName: "Danh sách đối tác");
ScreenActive newPartnerPage =
    ScreenActive(router: "/newPartner", pageDisplayName: "Thêm mới đối tác");
ScreenActive editPartnerPage =
    ScreenActive(router: "/editPartner", pageDisplayName: "Sửa thông tin");
ScreenActive itemPage =
    ScreenActive(router: "/item", pageDisplayName: "Quản lý hàng");
ScreenActive newItemPage =
    ScreenActive(router: "/newItem", pageDisplayName: "Thêm mặt hàng mới");
ScreenActive editItemPage =
    ScreenActive(router: "/editItem", pageDisplayName: "Sửa thông tin");
ScreenActive userPage =
    ScreenActive(router: "/users", pageDisplayName: "Danh sách tài khoản");
ScreenActive newUserPage =
    ScreenActive(router: "/newUser", pageDisplayName: "Thêm tài khoản");
List<DauMucItems> listButtonMenu = [
  DauMucItems("Đối tác", [partnerPage, newPartnerPage],
      Image.asset("assets/images/partner.png")),
  DauMucItems(
      "Mua - bán hàng",
      [purchasePage, purchaseHistoryPage, salePage, saleHistoryPage],
      Image.asset("assets/images/sale.png")),
  DauMucItems("Hàng hóa", [itemPage, newItemPage],
      Image.asset("assets/images/product.png")),
  DauMucItems("Tài khoản", [userPage,newUserPage], Image.asset("assets/images/users.png"))
];

NavigationController navigationController = NavigationController.instance;

class ScreenActive {
  late String router;
  late String pageDisplayName;

  ScreenActive({required this.router, required this.pageDisplayName});
}
