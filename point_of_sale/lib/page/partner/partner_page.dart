import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common.dart';
import '../../controller/partnerPage/partner_controller.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import 'package:universal_html/html.dart' as html;
import '../../default_widget/dropdown_search.dart';
import '../../default_widget/pagination.dart';
import '../../router/router.dart';
import 'edit_partner_page.dart';

class PartnerPage extends StatefulWidget {
  const PartnerPage({super.key});

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {
  var controller = Get.put(PartnerController());

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 900
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 230,
                      height: 40,
                      child: customTextFormField(
                        onChange: (value) async {
                          controller.listSupplierIsSelected == true
                              ? await controller.fetchSuppliers()
                              : await controller.fetchCustomers();
                          controller.update();
                        },
                        hintText: 'Tìm kiếm: Tên, Số điện thoại',
                        controller: controller.filter,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 230,
                      height: 40,
                      child: DropdownSearch(
                        labelText: 'Loại đối tác',
                        itemDefault: controller.listSupplierIsSelected == true
                            ? 'Nhà cung cấp'
                            : 'Khách hàng',
                        menuHeight: 120,
                        listItem: (int pageNumber, String filter) async {
                          return [
                            {'value': 'Nhà cung cấp', 'id': true},
                            {'value': 'Khách hàng', 'id': false},
                          ];
                        },
                        onChange: (value) {
                          controller.listSupplierIsSelected = value['id'];
                          controller.update();
                        },
                        enableSearch: false,
                        enableLazyLoading: false,
                      ),
                    )
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
                            width: 10,
                          ),
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
                                  text:
                                      controller.listSupplierIsSelected == true
                                          ? 'Tên nhà cung cấp'
                                          : 'Tên khách hàng',
                                  color: primaryColor,
                                  size: 16,
                                  weight: FontWeight.w600)),
                          Container(
                            alignment: Alignment.center,
                            width: 85,
                            child: customText(
                                text: 'Ngày sinh',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          Expanded(
                              child: Center(
                            child: customText(
                                text: 'Địa chỉ',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          )),
                          Container(
                            alignment: Alignment.center,
                            width: 90,
                            child: customText(
                                text: 'SĐT',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          Expanded(
                              child: Center(
                            child: customText(
                                text: 'Email',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          )),
                          const SizedBox(
                            width: 80,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GetBuilder(
                          builder: (PartnerController controller) {
                            return FutureBuilder(
                                future:
                                    controller.listSupplierIsSelected == true
                                        ? controller.fetchSuppliers()
                                        : controller.fetchCustomers(),
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
                                            itemCount: controller
                                                        .listSupplierIsSelected ==
                                                    true
                                                ? controller.suppliers.length
                                                : controller.customers.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black12,
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
                                                                .all(5),
                                                        child: SizedBox(
                                                            width: 40,
                                                            child: Center(
                                                                child: customText(
                                                                    maxLine: 1,
                                                                    text: controller.listSupplierIsSelected ==
                                                                            true
                                                                        ? controller
                                                                            .suppliers[
                                                                                index]
                                                                            .Id
                                                                            .toString()
                                                                        : controller
                                                                            .customers[index]
                                                                            .Id
                                                                            .toString()))),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                          child: customText(
                                                              text: controller
                                                                          .listSupplierIsSelected ==
                                                                      true
                                                                  ? controller
                                                                      .suppliers[
                                                                          index]
                                                                      .Name!
                                                                  : controller
                                                                      .customers[
                                                                          index]
                                                                      .Name!)),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 85,
                                                        child: customText(
                                                            text: controller
                                                                        .listSupplierIsSelected ==
                                                                    true
                                                                ? convertDate(controller
                                                                    .suppliers[
                                                                        index]
                                                                    .Birthday!)
                                                                : convertDate(controller
                                                                    .customers[
                                                                        index]
                                                                    .Birthday!)),
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: customText(
                                                              maxLine: 1,
                                                              text: controller
                                                                          .listSupplierIsSelected ==
                                                                      true
                                                                  ? controller
                                                                      .suppliers[
                                                                          index]
                                                                      .Address!
                                                                  : controller
                                                                      .customers[
                                                                          index]
                                                                      .Address!),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 90,
                                                        child: customText(
                                                            text: controller
                                                                        .listSupplierIsSelected ==
                                                                    true
                                                                ? controller
                                                                    .suppliers[
                                                                        index]
                                                                    .Phone!
                                                                : controller
                                                                    .customers[
                                                                        index]
                                                                    .Phone!),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: customText(
                                                              text: controller
                                                                          .listSupplierIsSelected ==
                                                                      true
                                                                  ? controller
                                                                      .suppliers[
                                                                          index]
                                                                      .Email!
                                                                  : controller
                                                                      .customers[
                                                                          index]
                                                                      .Email!),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          Uri baseUri =
                                                              Uri.base;
                                                          String baseUrl =
                                                              '${baseUri.scheme}://${baseUri.host}:${baseUri.port}/#';
                                                          html.window.open(
                                                              '$baseUrl${editPartnerPage.router}?id=${controller.listSupplierIsSelected == true ? controller.suppliers[index].Id! : controller.customers[index].Id!}&isSupplier=${controller.listSupplierIsSelected}',
                                                              '_blank');
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () async {
                                                          await controller.btnRemoveOnClick(
                                                              controller.listSupplierIsSelected ==
                                                                      true
                                                                  ? controller
                                                                      .suppliers[
                                                                          index]
                                                                      .Id!
                                                                  : controller
                                                                      .customers[
                                                                          index]
                                                                      .Id!);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
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
                                                displayItemCount: 5,
                                                onPageChanged: (page) {
                                                  controller.pageNumber = page;
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
                    SizedBox(
                      height: 40,
                      child: customTextFormField(
                        onChange: (value) async {
                          controller.listSupplierIsSelected == true
                              ? await controller.fetchSuppliers()
                              : await controller.fetchCustomers();
                          controller.update();
                        },
                        hintText: 'Tìm kiếm: Tên, Số điện thoại',
                        controller: controller.filter,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: DropdownSearch(
                        labelText: 'Loại đối tác',
                        itemDefault: controller.listSupplierIsSelected == true
                            ? 'Nhà cung cấp'
                            : 'Khách hàng',
                        menuHeight: 120,
                        listItem: (int pageNumber, String filter) async {
                          return [
                            {'value': 'Nhà cung cấp', 'id': true},
                            {'value': 'Khách hàng', 'id': false},
                          ];
                        },
                        onChange: (value) {
                          controller.listSupplierIsSelected = value['id'];
                          controller.update();
                        },
                        enableSearch: false,
                        enableLazyLoading: false,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 700,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
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
                                          text: controller
                                                      .listSupplierIsSelected ==
                                                  true
                                              ? 'Tên nhà cung cấp'
                                              : 'Tên khách hàng',
                                          color: primaryColor,
                                          size: 16,
                                          weight: FontWeight.w600)),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 85,
                                    child: customText(
                                        text: 'Ngày sinh',
                                        color: primaryColor,
                                        size: 16,
                                        weight: FontWeight.w600),
                                  ),
                                  Expanded(
                                      child: Center(
                                    child: customText(
                                        text: 'Địa chỉ',
                                        color: primaryColor,
                                        size: 16,
                                        weight: FontWeight.w600),
                                  )),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 90,
                                    child: customText(
                                        text: 'SĐT',
                                        color: primaryColor,
                                        size: 16,
                                        weight: FontWeight.w600),
                                  ),
                                  Expanded(
                                      child: Center(
                                    child: customText(
                                        text: 'Email',
                                        color: primaryColor,
                                        size: 16,
                                        weight: FontWeight.w600),
                                  )),
                                  const SizedBox(
                                    width: 80,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: GetBuilder(
                                  builder: (PartnerController controller) {
                                    return FutureBuilder(
                                        future:
                                            controller.listSupplierIsSelected ==
                                                    true
                                                ? controller.fetchSuppliers()
                                                : controller.fetchCustomers(),
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
                                                                .listSupplierIsSelected ==
                                                            true
                                                        ? controller
                                                            .suppliers.length
                                                        : controller
                                                            .customers.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8.0),
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
                                                                        .all(5),
                                                                child: SizedBox(
                                                                    width: 40,
                                                                    child: Center(
                                                                        child: customText(
                                                                            maxLine:
                                                                                1,
                                                                            text: controller.listSupplierIsSelected == true
                                                                                ? controller.suppliers[index].Id.toString()
                                                                                : controller.customers[index].Id.toString()))),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                  child: customText(
                                                                      text: controller.listSupplierIsSelected ==
                                                                              true
                                                                          ? controller
                                                                              .suppliers[
                                                                                  index]
                                                                              .Name!
                                                                          : controller
                                                                              .customers[index]
                                                                              .Name!)),
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 85,
                                                                child: customText(
                                                                    text: controller.listSupplierIsSelected ==
                                                                            true
                                                                        ? convertDate(controller
                                                                            .suppliers[
                                                                                index]
                                                                            .Birthday!)
                                                                        : convertDate(controller
                                                                            .customers[index]
                                                                            .Birthday!)),
                                                              ),
                                                              Expanded(
                                                                child: Center(
                                                                  child: customText(
                                                                      maxLine:
                                                                          1,
                                                                      text: controller.listSupplierIsSelected ==
                                                                              true
                                                                          ? controller
                                                                              .suppliers[
                                                                                  index]
                                                                              .Address!
                                                                          : controller
                                                                              .customers[index]
                                                                              .Address!),
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 90,
                                                                child: customText(
                                                                    text: controller.listSupplierIsSelected ==
                                                                            true
                                                                        ? controller
                                                                            .suppliers[
                                                                                index]
                                                                            .Phone!
                                                                        : controller
                                                                            .customers[index]
                                                                            .Phone!),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: customText(
                                                                      maxLine:
                                                                          1,
                                                                      text: controller.listSupplierIsSelected ==
                                                                              true
                                                                          ? controller
                                                                              .suppliers[
                                                                                  index]
                                                                              .Email!
                                                                          : controller
                                                                              .customers[index]
                                                                              .Email!),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  Get.to(() =>
                                                                      Material(
                                                                        child:
                                                                            Scaffold(
                                                                          appBar:
                                                                              AppBar(
                                                                            backgroundColor:
                                                                                primaryColor,
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                            title: customText(
                                                                                text: 'Sửa thông tin',
                                                                                color: Colors.white,
                                                                                size: 22),
                                                                          ),
                                                                          body:
                                                                              EditPartnerPage(
                                                                            supplier: controller.listSupplierIsSelected == true
                                                                                ? controller.suppliers[index]
                                                                                : null,
                                                                            customer: controller.listSupplierIsSelected == false
                                                                                ? controller.customers[index]
                                                                                : null,
                                                                            isSupplier:
                                                                                controller.listSupplierIsSelected,
                                                                          ),
                                                                        ),
                                                                      ));
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  await controller.btnRemoveOnClick(controller
                                                                              .listSupplierIsSelected ==
                                                                          true
                                                                      ? controller
                                                                          .suppliers[
                                                                              index]
                                                                          .Id!
                                                                      : controller
                                                                          .customers[
                                                                              index]
                                                                          .Id!);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
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
                                                        currentPage: controller
                                                            .pageNumber,
                                                        totalPage: controller
                                                            .totalPageItem,
                                                        displayItemCount: 5,
                                                        onPageChanged: (page) {
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
