import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:number_to_vietnamese_words/number_to_vietnamese_words.dart';
import 'package:point_of_sale/api.dart';
import 'package:point_of_sale/models/purchase.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:point_of_sale/router/router.dart';
import 'package:printing/printing.dart';
import 'package:quickalert/quickalert.dart';
import 'package:universal_html/html.dart' as html;
import '../../common.dart';
import '../../default_widget/custom_button.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/dropdown_search.dart';
import '../../models/item.dart';
import '../../models/pdf_service.dart';

class BillPurchaseController extends GetxController {
  TextEditingController supplierTextEditingController = TextEditingController();
  final box = GetStorage();
  late Purchase billPurchase;
  Supplier? partnerSelect;
  bool? btnOnclick = false;

  @override
  void onInit() {
    super.onInit();
    partnerSelect = Supplier();
    billPurchase =
        Purchase(purchaseDetails: [], EmployeeId: box.read('user')['Id']);
  }

  Future<List<Map<String, dynamic>>> fetchSuppliers(
      {required String filter, required int pageNumber}) async {
    List<Supplier> tmp = (await Api.getSuppliers(
        filter: filter, pageNumber: pageNumber))['suppliers'];
    return tmp.map((obj) {
      return {
        'supplierSelect': obj,
        'value': obj.Name,
      };
    }).toList();
  }

  void addItemToBill(Item item) {
    PurchaseDetails billDetails = billPurchase.purchaseDetails!.firstWhere(
      (e) => e.ItemId == item.Id,
      orElse: () => PurchaseDetails(),
    );
    if (billDetails.ItemId == null) {
      billDetails.ItemId = item.Id;
      billDetails.ItemName = item.Name;
      billDetails.Price = item.SalePrice;
      billDetails.Quantity = 1;
      billDetails.Unit = item.unitDetails!.UnitName;
      billPurchase.purchaseDetails!.add(billDetails);
    } else {
      billDetails.Quantity = billDetails.Quantity! + 1;
    }
    itemOnChanged();
    update();
  }

  void removeItem(PurchaseDetails item) {
    billPurchase.purchaseDetails!.remove(item);
    itemOnChanged();
    update();
  }

  void itemOnChanged() {
    if (billPurchase.purchaseDetails!.isEmpty) {
      billPurchase.PurchaseAmount = 0;
      billPurchase.PurchaseQty = 0;
      return;
    }
    billPurchase.PurchaseAmount = 0;
    billPurchase.PurchaseQty = 0;
    for (var item in billPurchase.purchaseDetails!) {
      billPurchase.PurchaseAmount =
          billPurchase.PurchaseAmount! + item.Quantity! * item.Price!;
      billPurchase.PurchaseQty = billPurchase.PurchaseQty! + item.Quantity!;
    }
  }

  void btnPayOnClick(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Container(
          width: sizeController.width - 80,
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        content: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, right: 10),
                  child: Column(
                    children: [
                      const Text(
                        'Danh sách sản phẩm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: List.generate(
                            billPurchase.purchaseDetails!.length,
                            (index) => Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SizedBox(
                                          width: 20,
                                          child: Center(
                                              child: customText(
                                                  text:
                                                      (index + 1).toString()))),
                                    ),
                                    Expanded(
                                      child: customText(
                                        text:
                                            '${billPurchase.purchaseDetails![index].ItemName}',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Center(
                                        child: customText(
                                            text: billPurchase
                                                .purchaseDetails![index]
                                                .Quantity
                                                .toString()),
                                      ),
                                    ),
                                    customText(
                                        text:
                                            '${billPurchase.purchaseDetails![index].Unit}  x  ${formatMoney(billPurchase.purchaseDetails![index].Price!)}'),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: customText(
                                          text: formatMoney(billPurchase
                                                  .purchaseDetails![index]
                                                  .Quantity! *
                                              billPurchase
                                                  .purchaseDetails![index]
                                                  .Price!),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: customText(text: 'Khách hàng: ')),
                              SizedBox(
                                width: 300,
                                child: DropdownSearch(
                                  menuHeight: 300,
                                  textEditingController:
                                      supplierTextEditingController,
                                  fontSize: 14,
                                  labelText: 'Chọn nhà cung cấp',
                                  hintTextSearch: 'Tìm theo: SĐT, Tên',
                                  listItem:
                                      (int pageNumber, String filter) async {
                                    return await fetchSuppliers(
                                        filter: filter, pageNumber: pageNumber);
                                  },
                                  onChange: (value) {
                                    setState(() {
                                      partnerSelect = value['supplierSelect'];
                                      billPurchase.SupplierId =
                                          partnerSelect!.Id;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 40,
                                child: customButton(
                                    text: 'Thêm mới',
                                    onPressed: () {
                                      Uri baseUri = Uri.base;
                                      String baseUrl =
                                          '${baseUri.scheme}://${baseUri.host}:${baseUri.port}/#';
                                      html.window.open(
                                          '$baseUrl${newPartnerPage.router}',
                                          '_blank');
                                    }),
                              ),
                            ],
                          ),
                          GetBuilder(
                            builder: (BillPurchaseController controller) {
                              return btnOnclick == true
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 90.0, top: 5),
                                      child: customText(
                                          text: 'Vui lòng chọn khách hàng!',
                                          color: Colors.red),
                                    )
                                  : Container(
                                      height: 10,
                                    );
                            },
                          ),
                          customText(
                              text: 'Địa chỉ: ${partnerSelect!.Address ?? ''}'),
                          const SizedBox(
                            height: 10,
                          ),
                          customText(
                              text:
                                  'Số điện thoại: ${partnerSelect!.Phone ?? ''}'),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        customText(
                            text:
                                'Tổng: ${formatMoney(billPurchase.PurchaseAmount!)} VNĐ',
                            size: 30),
                        customText(
                            text:
                                'Bằng chữ: ${int.parse(billPurchase.PurchaseAmount!.toString()).toVietnameseWords()} đồng',
                            size: 20),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (billPurchase.SupplierId == null) {
                          btnOnclick = true;
                          update();
                          return;
                        }
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: 'Xác nhận thanh toán bằng tiền mặt',
                            text:
                                'Số tiền: ${formatMoney(billPurchase.PurchaseAmount!)} VNĐ',
                            onConfirmBtnTap: () async {
                              Get.back(closeOverlays: true);
                              bool success = false;
                              success =
                                  await Api.addPurchase(purchase: billPurchase);
                              if (success) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: 'Thanh toán thành công',
                                  showConfirmBtn: false,
                                );
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                await Printing.layoutPdf(
                                    onLayout: (_) => PdfService()
                                        .printPurchasePdf(billPurchase));

                                //reset
                                partnerSelect = Supplier();
                                supplierTextEditingController.text = '';
                                billPurchase = Purchase(
                                    purchaseDetails: [],
                                    EmployeeId: box.read('user')['Id']);
                                update();
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  text: 'Thanh toán không thành công',
                                  backgroundColor: Colors.white,
                                  titleColor: Colors.black,
                                  textColor: Colors.black,
                                );
                              }
                            });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.lightBlue),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Thanh toán bằng tiền mặt",
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 30,
                            child: Image.asset(
                              'images/money.png',
                              fit: BoxFit.contain,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (billPurchase.SupplierId == null) {
                          btnOnclick = true;
                          update();
                          return;
                        }

                        //Mô phỏng thanh toán thành công
                        await Future.delayed(const Duration(seconds: 5));
                        billPurchase.PaymentMethod = 'credit card';
                        Get.back(closeOverlays: true);
                        bool success = false;
                        success = await Api.addPurchase(purchase: billPurchase);
                        if (success) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Thanh toán thành công',
                            showConfirmBtn: false,
                          );
                          await Future.delayed(const Duration(seconds: 2));
                          await Printing.layoutPdf(
                              onLayout: (_) =>
                                  PdfService().printPurchasePdf(billPurchase));
                          //reset
                          partnerSelect = Supplier();
                          supplierTextEditingController.text = '';
                          billPurchase = Purchase(
                              purchaseDetails: [],
                              EmployeeId: box.read('user')['Id']);
                          update();
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Thanh toán không thành công',
                            backgroundColor: Colors.white,
                            titleColor: Colors.black,
                            textColor: Colors.black,
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.orange),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Thanh toán bằng chuyển khoản",
                              style: TextStyle(color: Colors.grey[100])),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 30,
                            child: Image.asset(
                              'images/credit-card.png',
                              fit: BoxFit.contain,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 40,
                      child: customButton(
                          text: 'Hủy',
                          onPressed: () {
                            Get.back();
                          },
                          color: Colors.red))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
