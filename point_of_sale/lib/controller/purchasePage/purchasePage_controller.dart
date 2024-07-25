import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:point_of_sale/models/purchase.dart';
import '../../api.dart';
import '../../models/item.dart';

class PurchasePageController extends GetxController {
  final box = GetStorage();
  Purchase? purchase;

  List<GroupDetails> groups = [];
  int? groupIdSelected;

  TextEditingController filter = TextEditingController();
  int totalPageItem = 1;
  int pageNumber = 1;
  bool inStock = false;
  List<Item> items = [];

  Future<void> fetchGroups() async {
    groups = await Api.getGroups();
  }
  Future<void> onChangeItemGroup() async {
    await fetchItems();
    update();
  }

  Future<void> fetchItems() async {
    var data = await Api.getItems(
        filter: filter.text,
        pageNumber: pageNumber,
        pageSize: 20,
        inStock: inStock,
        groupId: groupIdSelected);
    totalPageItem = data['totalPage'];
    items = data['items'];
  }

  @override
  void onInit() {
    super.onInit();
    purchase =
        Purchase(purchaseDetails: [], EmployeeId: box.read('user')['Id']);
  }
}
