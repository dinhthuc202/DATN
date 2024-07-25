import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api.dart';
import '../../default_widget/custom_text.dart';
import '../../models/item.dart';

class ItemController extends GetxController {
  List<Item> items = [];
  TextEditingController filter = TextEditingController();
  int totalPageItem = 1;
  int pageNumber = 1;
  int? groupIdSelected;
  bool inStock = false;
  bool sortByNewest = false;

  Future<List<Map<String, dynamic>>> fetchGroups() async {
    List<GroupDetails> tmp = await Api.getGroups();

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
        groupId: groupIdSelected,
        sortByNewest: sortByNewest);
    totalPageItem = data['totalPage'];
    items = data['items'];
  }

  Future<void> btnRemoveOnClick(int itemId) async {
    Get.dialog(
      AlertDialog(
        title: Center(
            child: customText(
                text: 'Xác nhận xóa',
                color: Colors.red,
                size: 23,
                weight: FontWeight.w600)),
        content: customText(
            text: 'Bạn có chắc chắn muốn xóa đối tác này không?', size: 15),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: 'Hủy', color: Colors.blue, size: 16),
          ),
          TextButton(
            onPressed: () async {
              await Api.deleteItem(itemId: itemId);
              items = [];
              update();
              Get.back();
            },
            child: customText(text: 'Xóa', color: Colors.red, size: 16),
          ),
        ],
      ),
    );
  }
}
