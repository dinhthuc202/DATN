import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../common.dart';
import '../../controller/purchasePage/purchase_history_controller.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import '../../default_widget/dropdown_search.dart';
import '../../default_widget/pagination.dart';
import '../../models/pdf_service.dart';
import '../../models/purchase.dart';
import '../../models/supplier.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({super.key});

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  var controller = Get.put(PurchaseHistoryController());

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 900
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 230,
                      height: 40,
                      child: customTextFormField(
                        onChange: (value) {
                          controller.update();
                        },
                        hintText: 'Tìm kiếm: Số chứng từ',
                        prefixIcon: const Icon(Icons.search),
                        controller: controller.filter,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 230,
                      height: 40,
                      child: DropdownSearch(
                        hintTextSearch: 'Tên, SĐT',
                        labelText: 'Nhà cung cấp',
                        itemDefault: 'Tất cả',
                        menuHeight: 200,
                        listItem: (int pageNumber, String filter) async {
                          return await controller.fetchSuppliers(
                              filter: filter, pageNumber: pageNumber);
                        },
                        onChange: (value) {
                          Supplier tmp = value['supplierSelect'];
                          controller.supplierIdFilter = tmp.Id;
                          controller.update();
                        },
                        enableLazyLoading: false,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            height: 33,
                            width: 130,
                            alignment: Alignment.centerRight,
                            child: customText(text: 'Xếp theo mới nhất:')),
                        StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return Checkbox(
                                value: controller.sortByNewest,
                                onChanged: (value) {
                                  setState(() {
                                    controller.sortByNewest =
                                        !controller.sortByNewest;
                                    controller.update();
                                  });
                                });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: customText(text: 'Lọc theo ngày:'),
                    ),
                    InkWell(
                      onTap: () {
                        Get.dialog(AlertDialog(
                          content: SizedBox(
                            width: 500,
                            height: 400,
                            child: SfDateRangePicker(
                              controller: controller.dateRangePickerController,
                              selectionMode: DateRangePickerSelectionMode.range,
                              showActionButtons: true,
                              onSubmit: (Object? value) {
                                PickerDateRange? selectedRange = controller
                                    .dateRangePickerController.selectedRange;
                                if (selectedRange != null) {
                                  DateTime? fromDate = selectedRange.startDate;
                                  DateTime? toDate = selectedRange.endDate;
                                  if (fromDate != null && toDate != null) {
                                    controller.fromDate = fromDate;
                                    controller.toDate = toDate;
                                    Get.back();
                                    controller.update();
                                    return;
                                  }
                                  Get.showSnackbar(
                                    const GetSnackBar(
                                      message: 'Vui lòng chọn khoảng ngày',
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              onCancel: () {
                                Get.back();
                              },
                            ),
                          ),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: GetBuilder(
                          builder: (PurchaseHistoryController controller) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 230,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                          width: 80,
                                          child: customText(text: 'Từ ngày: ')),
                                      Expanded(
                                        child: Center(
                                            child: customText(
                                                text: convertDate(
                                                    controller.fromDate))),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 230,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                          width: 80,
                                          child:
                                              customText(text: 'Đến ngày: ')),
                                      Expanded(
                                        child: Center(
                                            child: customText(
                                                text: convertDate(
                                                    controller.toDate))),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                              width: 40,
                              child: Center(
                                child: customText(
                                    text: 'ID',
                                    color: primaryColor,
                                    size: 16,
                                    weight: FontWeight.w600),
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 80,
                            child: customText(
                                text: 'Ngày mua',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Center(
                              child: customText(
                                  text: 'Nhân viên mua',
                                  color: primaryColor,
                                  size: 16,
                                  weight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: customText(
                                  text: 'Nhà cung cấp',
                                  color: primaryColor,
                                  size: 16,
                                  weight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 100,
                            child: customText(
                                text: 'Tổng tiền',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 120,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GetBuilder(
                          builder: (PurchaseHistoryController controller) {
                            return FutureBuilder(
                                future: controller.fetchPurchases(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return SelectionArea(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  controller.purchases.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                Purchase purchase =
                                                    controller.purchases[index];
                                                return ExpansionTile(
                                                    title: Row(
                                                      children: [
                                                        SizedBox(
                                                            width: 40,
                                                            child: Center(
                                                                child: customText(
                                                                    maxLine: 1,
                                                                    text: purchase
                                                                            .Id
                                                                        .toString()))),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                            width: 80,
                                                            alignment: Alignment
                                                                .center,
                                                            child: customText(
                                                                text: convertDate(
                                                                    purchase
                                                                        .Date!))),
                                                        Expanded(
                                                            child: Center(
                                                          child: customText(
                                                              text: purchase
                                                                  .EmployeeName!),
                                                        )),
                                                        Expanded(
                                                            child: Center(
                                                          child: customText(
                                                              text: purchase
                                                                  .SupplierName!),
                                                        )),
                                                        Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            width: 100,
                                                            child: customText(
                                                                text: formatMoney(
                                                                    purchase
                                                                        .PurchaseAmount!))),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            await Printing.layoutPdf(
                                                                onLayout: (_) =>
                                                                    PdfService()
                                                                        .printPurchasePdf(
                                                                            purchase));
                                                          },
                                                          icon: const Icon(
                                                            Icons.print,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 30.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: customText(
                                                                  text:
                                                                      'Chi tiết:'),
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: purchase
                                                                    .purchaseDetails!
                                                                    .map((i) =>
                                                                        SizedBox(
                                                                          height:
                                                                              40,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  child: customText(text: i.ItemName!),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 100,
                                                                                child: customText(text: 'x${i.Quantity!}'),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.centerRight,
                                                                                width: 100,
                                                                                child: customText(text: formatMoney(i.Price!)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ]);
                                              },
                                            ),
                                          ),
                                          controller.totalPageItem > 1
                                              ? WebPagination(
                                                  currentPage:
                                                      controller.pageNumber,
                                                  totalPage:
                                                      controller.totalPageItem,
                                                  displayItemCount: 5,
                                                  onPageChanged: (page) {
                                                    controller.pageNumber =
                                                        page;
                                                    controller.update();
                                                  })
                                              : Container()
                                        ],
                                      ),
                                    );
                                  }
                                  return Container();
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 80,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: SizedBox(
                        height: 40,
                        child: customTextFormField(
                          onChange: (value) {
                            controller.update();
                          },
                          hintText: 'Tìm kiếm: Số chứng từ',
                          prefixIcon: const Icon(Icons.search),
                          controller: controller.filter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: SizedBox(
                        height: 40,
                        child: DropdownSearch(
                          hintTextSearch: 'Tên, SĐT',
                          labelText: 'Nhà cung cấp',
                          itemDefault: 'Tất cả',
                          menuHeight: 200,
                          listItem: (int pageNumber, String filter) async {
                            return await controller.fetchSuppliers(
                                filter: filter, pageNumber: pageNumber);
                          },
                          onChange: (value) {
                            Supplier tmp = value['supplierSelect'];
                            controller.supplierIdFilter = tmp.Id;
                            controller.update();
                          },
                          enableLazyLoading: false,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10, left: 10),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              width: 120,
                              child: customText(text: 'Lọc theo ngày:')),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.dialog(AlertDialog(
                                content: SizedBox(
                                  width: 500,
                                  height: 400,
                                  child: SfDateRangePicker(
                                    controller:
                                        controller.dateRangePickerController,
                                    selectionMode:
                                        DateRangePickerSelectionMode.range,
                                    showActionButtons: true,
                                    onSubmit: (Object? value) {
                                      PickerDateRange? selectedRange =
                                          controller.dateRangePickerController
                                              .selectedRange;
                                      if (selectedRange != null) {
                                        DateTime? fromDate =
                                            selectedRange.startDate;
                                        DateTime? toDate =
                                            selectedRange.endDate;
                                        if (fromDate != null &&
                                            toDate != null) {
                                          controller.fromDate = fromDate;
                                          controller.toDate = toDate;
                                          Get.back();
                                          controller.update();
                                          return;
                                        }
                                        Get.showSnackbar(
                                          const GetSnackBar(
                                            message:
                                                'Vui lòng chọn khoảng ngày',
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    onCancel: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                              ));
                            },
                            child: Container(
                              height: 65,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: GetBuilder(
                                builder:
                                    (PurchaseHistoryController controller) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                              width: 80,
                                              child: customText(
                                                  text: 'Từ ngày: ')),
                                          Expanded(
                                            child: Center(
                                                child: customText(
                                                    text: convertDate(
                                                        controller
                                                            .fromDate))),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                              width: 80,
                                              child: customText(
                                                  text: 'Đến ngày: ')),
                                          Expanded(
                                            child: Center(
                                                child: customText(
                                                    text: convertDate(
                                                        controller.toDate))),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 33,
                              width: 130,
                              alignment: Alignment.centerRight,
                              child: customText(text: 'Xếp theo mới nhất:')),
                          StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return Checkbox(
                                  value: controller.sortByNewest,
                                  onChanged: (value) {
                                    setState(() {
                                      controller.sortByNewest =
                                          !controller.sortByNewest;
                                      controller.update();
                                    });
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 500,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                      width: 40,
                                      child: Center(
                                        child: customText(
                                            text: 'ID',
                                            color: primaryColor,
                                            size: 16,
                                            weight: FontWeight.w600),
                                      )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: customText(
                                        text: 'Ngày mua',
                                        color: primaryColor,
                                        size: 16,
                                        weight: FontWeight.w600),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: customText(
                                          text: 'Nhà cung cấp',
                                          color: primaryColor,
                                          size: 16,
                                          weight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 100,
                                    child: customText(
                                        text: 'Tổng tiền',
                                        color: primaryColor,
                                        size: 16,
                                        weight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 120,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: GetBuilder(
                                  builder:
                                      (PurchaseHistoryController controller) {
                                    return FutureBuilder(
                                        future: controller.fetchPurchases(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return SelectionArea(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .purchases.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        Purchase purchase =
                                                            controller
                                                                    .purchases[
                                                                index];
                                                        return ExpansionTile(
                                                            title: Row(
                                                              children: [
                                                                SizedBox(
                                                                    width: 40,
                                                                    child: Center(
                                                                        child: customText(
                                                                            maxLine:
                                                                                1,
                                                                            text:
                                                                                purchase.Id.toString()))),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Container(
                                                                    width: 80,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: customText(
                                                                        text: convertDate(
                                                                            purchase.Date!))),
                                                                Expanded(
                                                                    child:
                                                                        Center(
                                                                  child: customText(
                                                                      text: purchase
                                                                          .SupplierName!),
                                                                )),
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    width: 100,
                                                                    child: customText(
                                                                        text: formatMoney(
                                                                            purchase.PurchaseAmount!))),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await Printing.layoutPdf(
                                                                        onLayout:
                                                                            (_) =>
                                                                                PdfService().printPurchasePdf(purchase));
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.print,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            30.0),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      child: customText(
                                                                          text:
                                                                              'Chi tiết:'),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: purchase
                                                                            .purchaseDetails!
                                                                            .map((i) =>
                                                                                SizedBox(
                                                                                  height: 40,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          child: customText(text: i.ItemName!),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 100,
                                                                                        child: customText(text: 'x${i.Quantity!}'),
                                                                                      ),
                                                                                      Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        width: 100,
                                                                                        child: customText(text: formatMoney(i.Price!)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ))
                                                                            .toList(),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ]);
                                                      },
                                                    ),
                                                  ),
                                                  controller.totalPageItem > 1
                                                      ? WebPagination(
                                                          currentPage:
                                                              controller
                                                                  .pageNumber,
                                                          totalPage: controller
                                                              .totalPageItem,
                                                          displayItemCount: 5,
                                                          onPageChanged:
                                                              (page) {
                                                            controller
                                                                    .pageNumber =
                                                                page;
                                                            controller.update();
                                                          })
                                                      : Container()
                                                ],
                                              ),
                                            );
                                          }
                                          return Container();
                                        });
                                  },
                                ),
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
          );
  }
}
