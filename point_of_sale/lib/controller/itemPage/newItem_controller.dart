import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import '../../api.dart';
import '../../models/item.dart';

class NewItemController extends GetxController {
  final formKey = GlobalKey<FormState>();
  Item item = Item();
  bool btnAddClick = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController purchaseController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController stockController = TextEditingController(text: '0');
  TextEditingController barCodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    purchaseController.dispose();
    salePriceController.dispose();
    stockController.dispose();
    barCodeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  String? validatorAction(dynamic value, {String? content}) {
    if (value == null || value.isEmpty) {
      return content ?? 'Vui lòng nhập đẩy đủ thông tin';
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchGroups() async {
    List<GroupDetails> tmp = await Api.getGroups();

    return tmp.map((obj) {
      return {
        'groupId': obj.Id,
        'value': obj.GroupName,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchUnits() async {
    List<UnitDetails> tmp = await Api.getUnits();

    return tmp.map((obj) {
      return {
        'unitId': obj.Id,
        'value': obj.UnitName,
      };
    }).toList();
  }

  Future btnAddOnCLick(BuildContext context, {required bool isEdit}) async {
    btnAddClick = true;
    if ((formKey.currentState?.validate() ?? false) &&
        item.UnitId != null &&
        item.GroupId != null) {
      bool success = false;
      item.Name = nameController.text;
      item.PurchasePrice = double.parse(purchaseController.text);
      item.SalePrice = double.parse(salePriceController.text);
      item.Stock = int.parse(stockController.text);
      item.BarCode = barCodeController.text;
      item.Description = descriptionController.text;

      success = isEdit == false
          ? await Api.addItem(item: item)
          : await Api.updateItem(item: item);
      if (success) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: isEdit == true ? 'Cập nhật thành công' : 'Thêm thành công',
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: isEdit == true
              ? 'Cập nhật không thành công'
              : 'Thêm không thành công',
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
        );
      }
    }
  }

  void fetchDataEdit({required Item itemInput}) {
    item.Id = itemInput.Id;
    item.UnitId = itemInput.UnitId;
    unitController.text = itemInput.unitDetails!.UnitName!;
    item.GroupId = itemInput.GroupId;
    groupController.text = itemInput.groupDetails!.GroupName!;
    nameController.text = itemInput.Name ?? '';
    purchaseController.text = itemInput.PurchasePrice.toString();
    salePriceController.text = itemInput.SalePrice.toString();
    stockController.text = itemInput.Stock.toString();
    barCodeController.text = itemInput.BarCode ?? '';
    descriptionController.text = itemInput.Description ?? '';
  }
}
