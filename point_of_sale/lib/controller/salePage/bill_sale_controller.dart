import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:number_to_vietnamese_words/number_to_vietnamese_words.dart';
import 'package:printing/printing.dart';
import 'package:quickalert/quickalert.dart';
import '../../api.dart';
import '../../common.dart';
import '../../default_widget/custom_button.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/dropdown_search.dart';
import '../../models/customer.dart';
import '../../models/item.dart';
import '../../models/pdf_service.dart';
import '../../models/sale.dart';
import 'package:universal_html/html.dart' as html;
import '../../page/partner/new_partner_page.dart';
import '../../router/router.dart';

class BillSaleController extends GetxController {
  TextEditingController customerTextEditingController = TextEditingController();
  final box = GetStorage();
  late Sale billSale;
  Customer? partnerSelect;
  bool? btnOnclick = false;

  @override
  void onInit() {
    super.onInit();
    partnerSelect = Customer();
    billSale = Sale(saleDetails: [], EmployeeId: box.read('user')['id']);
  }

  Future<List<Map<String, dynamic>>> fetchCustomers(
      {required String filter, required int pageNumber}) async {
    List<Customer> tmp = (await Api.getCustomers(
        filter: filter, pageNumber: pageNumber))['customers'];
    return tmp.map((obj) {
      return {
        'customerSelect': obj,
        'value': obj.Name,
      };
    }).toList();
  }

  int calTotalItem() {
    int tmp = 0;
    for (var item in billSale.saleDetails!) {
      tmp = tmp + item.Quantity!;
    }
    return tmp;
  }

  void addItemToBill(Item item) {
    SaleDetails billDetails = billSale.saleDetails!.firstWhere(
      (e) => e.ItemId == item.Id,
      orElse: () => SaleDetails(),
    );
    if (billDetails.ItemId == null) {
      billDetails.ItemId = item.Id;
      billDetails.ItemName = item.Name;
      billDetails.Price = item.SalePrice;
      billDetails.Quantity = 1;
      billDetails.Unit = item.unitDetails!.UnitName;
      billSale.saleDetails!.add(billDetails);
    } else {
      billDetails.Quantity = billDetails.Quantity! + 1;
    }
    itemOnChanged();
    update();
  }

  void removeItem(dynamic item) {
    billSale.saleDetails!.remove(item);
    itemOnChanged();
    update();
  }

  void itemOnChanged() {
    if (billSale.saleDetails!.isEmpty) {
      billSale.SaleAmount = 0;
      billSale.SaleQty = 0;
      return;
    }
    billSale.SaleAmount = 0;
    billSale.SaleQty = 0;
    for (var item in billSale.saleDetails!) {
      billSale.SaleAmount = billSale.SaleAmount! + item.Quantity! * item.Price!;
      billSale.SaleQty = billSale.SaleQty! + item.Quantity!;
    }
  }

  Future<Item> getItemByBarCode(String barcode) async {
    Item? data = await Api.getItemByBarcode(barcode: barcode);
    return data;
  }

  Image? qrPay;

  Future<void> loadQRCode() async {
    qrPay = Image.memory(
      const Base64Decoder()
          .convert(await Api.generateQRCode(billSale.SaleAmount!)),
      fit: BoxFit.contain,
    );
  }

  Future<void> btnPayWithCashOnClick(BuildContext context) async {
    if (billSale.CustomerId == null) {
      btnOnclick = true;
      update();
      return;
    }
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Xác nhận thanh toán bằng tiền mặt',
        text: 'Số tiền: ${formatMoney(billSale.SaleAmount!)} VNĐ',
        onConfirmBtnTap: () async {
          Get.back(closeOverlays: true);
          bool success = false;
          success = await Api.addSale(sale: billSale);
          if (success) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Thanh toán thành công',
              showConfirmBtn: false,
            );
            await Future.delayed(const Duration(seconds: 2));
            await Printing.layoutPdf(
                onLayout: (_) => PdfService().printSalePdf(billSale));
            //reset

            partnerSelect = Customer();
            customerTextEditingController.text = '';
            billSale =
                Sale(saleDetails: [], EmployeeId: box.read('user')['Id']);
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
  }

  Future<void> btnPayWithCreditCard(BuildContext context) async {
    if (billSale.CustomerId == null) {
      btnOnclick = true;
      update();
      return;
    }
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        content: FutureBuilder(
          future: loadQRCode().then((_) => null),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return MediaQuery.of(context).size.width > 900
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9 * 0.25,
                    height: MediaQuery.of(context).size.width * 0.9 * 0.25,
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : qrPay,
                  )
                : SizedBox(
                    height: 400,
                    width: 400,
                    child: (snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : qrPay),
                  );
          },
        ),
      ),
    );
    //Mô phỏng thanh toán thành công
    await Future.delayed(const Duration(seconds:10 ));
    billSale.PaymentMethod = 'credit card';
    Get.back(closeOverlays: true);
    bool success = false;
    success = await Api.addSale(sale: billSale);
    if (success) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Thanh toán thành công',
        showConfirmBtn: false,
      );
      await Future.delayed(const Duration(seconds: 2));

      //Chức năng in trên mobile hiện tại chưa có thiết bị kết nối --> lỗi
      if(MediaQuery.of(context).size.width > 900){
        await Printing.layoutPdf(
            onLayout: (_) => PdfService().printSalePdf(billSale));
      }
      //reset
      partnerSelect = Customer();
      customerTextEditingController.text = '';
      billSale = Sale(saleDetails: [], EmployeeId: box.read('user')['Id']);
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
  }

  void btnPayOnClick(BuildContext context) {
    MediaQuery.of(context).size.width > 900
        ?
        //large screen
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                                  billSale.saleDetails!.length,
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
                                                        text: (index + 1)
                                                            .toString()))),
                                          ),
                                          Expanded(
                                            child: customText(
                                              text:
                                                  '${billSale.saleDetails![index].ItemName}',
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
                                                  text: billSale
                                                      .saleDetails![index]
                                                      .Quantity
                                                      .toString()),
                                            ),
                                          ),
                                          customText(
                                              text:
                                                  '${billSale.saleDetails![index].Unit}  x  ${formatMoney(billSale.saleDetails![index].Price!)}'),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: customText(
                                                text: formatMoney(billSale
                                                        .saleDetails![index]
                                                        .Quantity! *
                                                    billSale.saleDetails![index]
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
                                        child:
                                            customText(text: 'Khách hàng: ')),
                                    SizedBox(
                                      width: 300,
                                      child: DropdownSearch(
                                        menuHeight: 300,
                                        textEditingController:
                                            customerTextEditingController,
                                        fontSize: 14,
                                        labelText: 'Chọn khách hàng',
                                        hintTextSearch: 'Tìm theo: SĐT, Tên',
                                        listItem: (int pageNumber,
                                            String filter) async {
                                          return await fetchCustomers(
                                              filter: filter,
                                              pageNumber: pageNumber);
                                        },
                                        onChange: (value) {
                                          setState(() {
                                            partnerSelect =
                                                value['customerSelect'];
                                            billSale.CustomerId =
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
                                  builder: (BillSaleController controller) {
                                    return btnOnclick == true
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 90.0, top: 5),
                                            child: customText(
                                                text:
                                                    'Vui lòng chọn khách hàng!',
                                                color: Colors.red),
                                          )
                                        : Container(
                                            height: 10,
                                          );
                                  },
                                ),
                                customText(
                                    text:
                                        'Địa chỉ: ${partnerSelect!.Address ?? ''}'),
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
                                      'Tổng: ${formatMoney(billSale.SaleAmount!)} VNĐ',
                                  size: 30),
                              customText(
                                  text:
                                      'Bằng chữ: ${int.parse(billSale.SaleAmount!.toString()).toVietnameseWords()} đồng',
                                  size: 20),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              await btnPayWithCashOnClick(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.lightBlue),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                    'assets/images/money.png',
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
                              await btnPayWithCreditCard(context);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.orange),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                    'assets/images/credit-card.png',
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
          )
        //mobile scree
        : Get.dialog(Material(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
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
                                billSale.saleDetails!.length,
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
                                                      text: (index + 1)
                                                          .toString()))),
                                        ),
                                        Expanded(
                                          child: customText(
                                            text:
                                                '${billSale.saleDetails![index].ItemName}',
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
                                                text: billSale
                                                    .saleDetails![index]
                                                    .Quantity
                                                    .toString()),
                                          ),
                                        ),
                                        customText(
                                            text:
                                                '${billSale.saleDetails![index].Unit}  x  ${formatMoney(billSale.saleDetails![index].Price!)}'),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: customText(
                                              text: formatMoney(billSale
                                                      .saleDetails![index]
                                                      .Quantity! *
                                                  billSale.saleDetails![index]
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
                                Expanded(
                                  child: DropdownSearch(
                                    menuHeight: 300,
                                    textEditingController:
                                        customerTextEditingController,
                                    fontSize: 14,
                                    labelText: 'Chọn khách hàng',
                                    hintTextSearch: 'Tìm theo: SĐT, Tên',
                                    listItem:
                                        (int pageNumber, String filter) async {
                                      return await fetchCustomers(
                                          filter: filter,
                                          pageNumber: pageNumber);
                                    },
                                    onChange: (value) {
                                      setState(() {
                                        partnerSelect = value['customerSelect'];
                                        billSale.CustomerId = partnerSelect!.Id;
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
                                        Get.dialog(Material(
                                            child: Scaffold(
                                                appBar: AppBar(
                                                  title: customText(
                                                      text: 'Thêm mới đối tác',
                                                      color: Colors.white,
                                                      size: 20),
                                                  iconTheme:
                                                      const IconThemeData(
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor: primaryColor,
                                                ),
                                                body: const NewPartnerPage())));
                                      }),
                                ),
                              ],
                            ),
                            GetBuilder(
                              builder: (BillSaleController controller) {
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
                                text:
                                    'Địa chỉ: ${partnerSelect!.Address ?? ''}'),
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
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          await btnPayWithCashOnClick(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.lightBlue),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
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
                                'assets/images/money.png',
                                fit: BoxFit.contain,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            await btnPayWithCreditCard(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.orange),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
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
                                  'assets/images/credit-card.png',
                                  fit: BoxFit.contain,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
              ),
            ),
          ));
  }
}
