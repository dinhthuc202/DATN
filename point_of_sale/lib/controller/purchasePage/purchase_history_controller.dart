import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/api.dart';
import 'package:point_of_sale/models/purchase.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/supplier.dart';

class PurchaseHistoryController extends GetxController {
  List<Purchase> purchases = [];

  TextEditingController filter = TextEditingController();
  int totalPageItem = 1;
  int pageNumber = 1;
  int? supplierIdFilter;
  bool sortByNewest = true;
  DateTime fromDate = DateTime.parse('2024-01-01');
  DateTime toDate = DateTime.now();
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  @override
  void onInit() {
    super.onInit();
    dateRangePickerController.selectedRange = PickerDateRange(fromDate, toDate);
  }

  Future<void> fetchPurchases() async {
    var data = await Api.getPurchases(
      supplierId: supplierIdFilter,
      filter: filter.text,
      pageNumber: pageNumber,
      pageSize: 20,
      sortByNewest: sortByNewest,
      fromDate: fromDate,
      toDate: toDate.add(const Duration(days: 1)),
    );
    totalPageItem = data['totalPage'];
    purchases = data['purchases'];
  }

  Future<List<Map<String, dynamic>>> fetchSuppliers(
      {required String filter, required int pageNumber}) async {
    List<Supplier> tmp = (await Api.getSuppliers(
        filter: filter, pageNumber: pageNumber))['suppliers'];
    Supplier all = Supplier(Id: null, Name: 'Tất cả');
    tmp.insert(0, all);
    return tmp.map((obj) {
      return {
        'supplierSelect': obj,
        'value': obj.Name,
      };
    }).toList();
  }
}
