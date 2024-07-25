import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/default_widget/custom_text.dart';
import 'package:point_of_sale/models/supplier.dart';
import '../../api.dart';
import '../../models/customer.dart';

class PartnerController extends GetxController {
  List<Customer> customers = [];
  List<Supplier> suppliers = [];

  //Dùng để theo dõi danh sách nào được lựa chọn
  bool listSupplierIsSelected = true;

  TextEditingController filter = TextEditingController();
  int totalPageItem = 1;
  int pageNumber = 1;

  Future<void> fetchCustomers() async {
    var data = await Api.getCustomers(
      filter: filter.text,
      pageNumber: pageNumber,
      pageSize: 20,
    );
    totalPageItem = data['totalPage'];
    customers = data['customers'];
  }

  Future<void> fetchSuppliers() async {
    var data = await Api.getSuppliers(
      filter: filter.text,
      pageNumber: pageNumber,
      pageSize: 20,
    );
    totalPageItem = data['totalPage'];
    suppliers = data['suppliers'];
  }

  Future<void> btnRemoveOnClick(int partnerId) async {
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
              if (listSupplierIsSelected) {
                await Api.deleteSupplier(supplierId: partnerId);
              } else {
                await Api.deleteCustomer(customerId: partnerId);
              }
              customers = [];
              suppliers = [];
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
