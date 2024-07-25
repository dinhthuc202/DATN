import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../common.dart';
import '../../controller/salePage/bill_sale_controller.dart';
import '../../controller/salePage/sale_page_controller.dart';
import '../../default_widget/custom_button.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import '../../default_widget/dropdown_search.dart';
import '../../default_widget/pagination.dart';
import '../../default_widget/scan_qrcode_sale.dart';
import '../../models/item.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  var controller = Get.put(SalePageController());
  var billController = Get.put(BillSaleController());
  final box = GetStorage();
FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 900
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 300,
                        child: customTextFormField(
                          onEditingComplete: ()async{
                            Item item = await billController.getItemByBarCode(controller.filter.text);
                            billController.addItemToBill(item);
                            billController.update();
                            controller.filter.text = '';
                          },
                            onChange: (value) async {
                              await controller.fetchItems();
                              controller.update();
                            },
                            hintText: 'Tìm kiếm: Tên, Barcode',
                            controller: controller.filter,
                            prefixIcon: const Icon(Icons.search))),
                    SizedBox(
                      height: 40,
                      child: FutureBuilder(
                          future: controller.fetchGroups(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return Row(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.groups.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: InkWell(
                                              onTap: () async {
                                                if (controller
                                                        .groupIdSelected !=
                                                    controller
                                                        .groups[index].Id) {
                                                  setState(() {
                                                    controller.groupIdSelected =
                                                        controller
                                                            .groups[index].Id;
                                                  });
                                                  await controller
                                                      .onChangeItemGroup();
                                                }
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(8)),
                                                    color: controller
                                                                .groupIdSelected ==
                                                            controller
                                                                .groups[index]
                                                                .Id
                                                        ? primaryColor
                                                        : Colors.grey[400],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: customText(
                                                        text: controller
                                                            .groups[index]
                                                            .GroupName!,
                                                        color: controller
                                                                    .groupIdSelected ==
                                                                controller
                                                                    .groups[
                                                                        index]
                                                                    .Id
                                                            ? Colors.white
                                                            : Colors.black),
                                                  )),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return Container();
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: customText(
                                          text: 'Danh sách sản phẩm',
                                          size: 20,
                                          weight: FontWeight.w700,
                                          color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 40,
                                          child: Center(
                                              child: customText(
                                                  text: 'ID',
                                                  color: primaryColor,
                                                  size: 16,
                                                  weight: FontWeight.w600))),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: customText(
                                              text: 'Tên sản phẩm',
                                              color: primaryColor,
                                              size: 16,
                                              weight: FontWeight.w600)),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: customText(
                                            text: 'Giá',
                                            color: primaryColor,
                                            size: 16,
                                            weight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 80,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GetBuilder(
                                    builder: (SalePageController controller) {
                                      return FutureBuilder(
                                          future: controller.fetchItems(),
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
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .items.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        var item = controller
                                                            .items[index];
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5,
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Container(
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black12,
                                                                    width: 1),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            8))),
                                                            child: Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  child: SizedBox(
                                                                      width: 40,
                                                                      child: Center(
                                                                          child:
                                                                              customText(text: item.Id.toString()))),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                    child: customText(
                                                                        text:
                                                                            '${item.Name}')),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    width: 100,
                                                                    child: customText(
                                                                        text: formatMoney(
                                                                            item.SalePrice!)),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 50,
                                                                  width: 60,
                                                                  child:
                                                                      MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      billController
                                                                          .addItemToBill(
                                                                              item);
                                                                    },
                                                                    color:
                                                                        buttonColor,
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topRight:
                                                                            Radius.circular(8),
                                                                        bottomRight:
                                                                            Radius.circular(8),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        customText(
                                                                      text:
                                                                          'Thêm',
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  controller.totalPageItem == 1
                                                      ? Container()
                                                      : WebPagination(
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
                                                ],
                                              );
                                            }
                                            return Container();
                                          });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 500,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text(
                                'Hóa đơn',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              GetBuilder(
                                builder: (BillSaleController controller) {
                                  var saleDetails =
                                      controller.billSale.saleDetails;
                                  return Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: saleDetails!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var item = saleDetails[index];
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: SizedBox(
                                                            width: 20,
                                                            child: Center(
                                                                child: customText(
                                                                    text: (index +
                                                                            1)
                                                                        .toString()))),
                                                      ),
                                                      Expanded(
                                                          child: customText(
                                                              text:
                                                                  '${item.ItemName}')),
                                                      IconButton(
                                                          onPressed: () {
                                                            billController
                                                                .removeItem(
                                                                    item);
                                                          },
                                                          icon: const Icon(
                                                            Icons.remove,
                                                            color: Colors.red,
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      customButton(
                                                          text: '-',
                                                          onPressed: () {
                                                            item.Quantity =
                                                                item.Quantity! -
                                                                    1;
                                                            if (item.Quantity ==
                                                                0) {
                                                              saleDetails
                                                                  .remove(item);
                                                            }
                                                            billController
                                                                .itemOnChanged();
                                                            billController
                                                                .update();
                                                          }),
                                                      SizedBox(
                                                          width: 40,
                                                          child: Center(
                                                              child: customText(
                                                                  text: item
                                                                          .Quantity
                                                                      .toString()))),
                                                      customButton(
                                                          text: '+',
                                                          onPressed: () {
                                                            item.Quantity =
                                                                item.Quantity! +
                                                                    1;
                                                            billController
                                                                .itemOnChanged();
                                                            billController
                                                                .update();
                                                          }),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      customText(
                                                          text:
                                                              '${item.Unit}  x  ${formatMoney(item.Price!)}'),
                                                      Expanded(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: customText(
                                                                  text: formatMoney(
                                                                      item.Quantity! *
                                                                          item.Price!)))),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        billController
                                                .billSale.saleDetails!.isEmpty
                                            ? Container()
                                            : SizedBox(
                                                height: 40,
                                                child: customButton(
                                                    text:
                                                        'Thanh toán: ${formatMoney(billController.billSale.SaleAmount!)} VNĐ',
                                                    onPressed: () async {
                                                      billController
                                                          .btnPayOnClick(
                                                              context);
                                                    })),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: DropdownSearch(
                    labelText: 'Loại mặt hàng',
                    itemDefault: 'Tất cả',
                    menuHeight: 200,
                    listItem: (int pageNumber, String filter) async {
                      return await controller.fetchGroups();
                    },
                    onChange: (value) {
                      controller.groupIdSelected = value['groupId'];
                      controller.update();
                    },
                    enableSearch: false,
                    enableLazyLoading: false,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: customTextFormField(
                        focusNode: focusNode,
                        onEditingComplete: ()async{
                          Item item = await billController.getItemByBarCode(controller.filter.text);
                          billController.addItemToBill(item);
                          billController.update();
                          controller.filter.text = '';
                          focusNode.requestFocus();
                        },
                          onChange: (value) async {
                            await controller.fetchItems();
                            controller.update();
                          },
                          hintText: 'Tìm kiếm: Tên, Barcode',
                          controller: controller.filter,
                          prefixIcon: const Icon(Icons.search)),
                    ),
                    IconButton(onPressed: (){
                      Get.dialog(const ScanQrcodeSale());
                    }, icon: const Icon(Icons.qr_code_scanner,color: primaryColor,))
                  ],
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: customText(
                                  text: 'Danh sách sản phẩm',
                                  size: 20,
                                  weight: FontWeight.w700,
                                  color: Colors.blueGrey),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: customText(
                                      text: 'Tên sản phẩm',
                                      color: primaryColor,
                                      size: 16,
                                      weight: FontWeight.w600)),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 100,
                                child: customText(
                                    text: 'Giá',
                                    color: primaryColor,
                                    size: 16,
                                    weight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GetBuilder(
                            builder: (SalePageController controller) {
                              return FutureBuilder(
                                  future: controller.fetchItems(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  controller.items.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var item =
                                                    controller.items[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5,
                                                          left: 10,
                                                          right: 10),
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12,
                                                            width: 1),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8))),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child: customText(
                                                                text:
                                                                    '${item.Name}')),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            width: 100,
                                                            child: customText(
                                                                text: formatMoney(
                                                                    item.SalePrice!)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          width: 70,
                                                          child: MaterialButton(
                                                            onPressed: () {
                                                              billController
                                                                  .addItemToBill(
                                                                      item);
                                                            },
                                                            color: buttonColor,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                            child: customText(
                                                              text: 'Thêm',
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          controller.totalPageItem == 1
                                              ? Container()
                                              : WebPagination(
                                                  currentPage:
                                                      controller.pageNumber,
                                                  totalPage:
                                                      controller.totalPageItem,
                                                  displayItemCount: 3,
                                                  onPageChanged: (page) {
                                                    controller.pageNumber =
                                                        page;
                                                    controller.update();
                                                  }),
                                          SizedBox(
                                            height: 40,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return SizedBox.expand(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Center(child: customText(text: 'Giỏ hàng',size: 18,)),
                                                            GetBuilder(
                                                              builder: (BillSaleController controller) {
                                                                var saleDetails =
                                                                    controller.billSale.saleDetails;
                                                                return saleDetails!.isEmpty ? Expanded(child: Center(child: Container(alignment:Alignment.center,child: customText(text: 'Giỏ hàng trống'),))): Expanded(
                                                                  child: Column(
                                                                    children: [
                                                                      Expanded(
                                                                        child: ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: saleDetails.length,
                                                                          itemBuilder:
                                                                              (BuildContext context,
                                                                              int index) {
                                                                            var item = saleDetails[index];
                                                                            return Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding:
                                                                                      const EdgeInsets
                                                                                          .all(5),
                                                                                      child: SizedBox(
                                                                                        width: 20,
                                                                                        child: Container(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: customText(
                                                                                            text: (index +
                                                                                                1)
                                                                                                .toString(),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                        child: customText(
                                                                                            text:
                                                                                            '${item.ItemName}')),
                                                                                    IconButton(
                                                                                        onPressed: () {
                                                                                          billController
                                                                                              .removeItem(
                                                                                              item);
                                                                                        },
                                                                                        icon: const Icon(
                                                                                          Icons.remove,
                                                                                          color:
                                                                                          Colors.red,
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    customButton(
                                                                                        text: '-',
                                                                                        onPressed: () {
                                                                                          item.Quantity =
                                                                                              item.Quantity! -
                                                                                                  1;
                                                                                          if (item.Quantity ==
                                                                                              0) {
                                                                                            saleDetails
                                                                                                .remove(
                                                                                                item);
                                                                                          }
                                                                                          billController
                                                                                              .itemOnChanged();
                                                                                          billController
                                                                                              .update();
                                                                                        }),
                                                                                    SizedBox(
                                                                                        width: 40,
                                                                                        child: Center(
                                                                                            child: customText(
                                                                                                text: item
                                                                                                    .Quantity
                                                                                                    .toString()))),
                                                                                    customButton(
                                                                                        text: '+',
                                                                                        onPressed: () {
                                                                                          item.Quantity =
                                                                                              item.Quantity! +
                                                                                                  1;
                                                                                          billController
                                                                                              .itemOnChanged();
                                                                                          billController
                                                                                              .update();
                                                                                        }),
                                                                                    const SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Expanded(
                                                                                        child: Container(
                                                                                            alignment:
                                                                                            Alignment
                                                                                                .centerRight,
                                                                                            child: customText(
                                                                                                text: formatMoney(
                                                                                                    item.Quantity! *
                                                                                                        item.Price!)))),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      billController.billSale.saleDetails!
                                                                          .isEmpty
                                                                          ? Container()
                                                                          : SizedBox(
                                                                          height: 40,
                                                                          child: customButton(
                                                                              text:
                                                                              'Thanh toán: ${formatMoney(billController.billSale.SaleAmount!)} VNĐ',
                                                                              onPressed: () async {
                                                                                billController
                                                                                    .btnPayOnClick(
                                                                                    context);
                                                                              })),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                const WidgetStatePropertyAll<Color>(buttonColor),
                                                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  GetBuilder(
                                                    builder: (BillSaleController controller) { return Center(
                                                      child: customText(
                                                        text: 'Giỏ hàng (${controller.calTotalItem()})',
                                                        color: textButtonColor,
                                                        size: 14,
                                                      ),
                                                    );  },
                                                  ),
                                                  Container(
                                                      alignment: Alignment.centerRight,
                                                      child: const Icon(
                                                        Icons.keyboard_arrow_up_outlined,
                                                        color: textButtonColor,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
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
                )),
              ],
            ),
          );
  }
}
