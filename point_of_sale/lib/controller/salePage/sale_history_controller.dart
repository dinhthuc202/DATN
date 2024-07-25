import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../api.dart';
import '../../models/customer.dart';
import '../../models/sale.dart';

class SaleHistoryController extends GetxController {
  List<Sale> sales = [];

  TextEditingController filter = TextEditingController();
  int totalPageItem = 1;
  int pageNumber = 1;
  int? customerIdFilter;
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
    var data = await Api.getSales(
      customerId: customerIdFilter,
      filter: filter.text,
      pageNumber: pageNumber,
      pageSize: 20,
      sortByNewest: sortByNewest,
      fromDate: fromDate,
      toDate: toDate.add(const Duration(days: 1)),
    );
    totalPageItem = data['totalPage'];
    sales = data['sales'];
  }

  Future<List<Map<String, dynamic>>> fetchSuppliers(
      {required String filter, required int pageNumber}) async {
    List<Customer> tmp = (await Api.getCustomers(
        filter: filter, pageNumber: pageNumber))['customers'];
    Customer all = Customer(Id: null, Name: 'Tất cả');
    tmp.insert(0, all);
    return tmp.map((obj) {
      return {
        'customerSelect': obj,
        'value': obj.Name,
      };
    }).toList();
  }
}
