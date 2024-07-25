import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/api.dart';
import '../../models/item.dart';

class SalePageController extends GetxController {
  List<GroupDetails> groups = [];
  int? groupIdSelected;

  TextEditingController filter = TextEditingController();
  int totalPageItem = 1;
  int pageNumber = 1;
  bool inStock = true;
  List<Item> items = [];

  Future<List<Map<String, dynamic>>> fetchGroups() async {
    List<GroupDetails> tmp = await Api.getGroups();
    groups  = tmp;
    GroupDetails allGroup = GroupDetails(Id: null, GroupName: 'Tất cả');
    tmp.insert(0, allGroup);

    return tmp.map((obj) {
      return {
        'groupId': obj.Id,
        'value': obj.GroupName,
      };
    }).toList();
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

  Future<void> onChangeItemGroup() async {
    await fetchItems();
    update();
  }
}
