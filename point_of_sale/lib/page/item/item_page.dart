import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common.dart';
import '../../controller/itemPage/item_controller.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import 'package:universal_html/html.dart' as html;
import '../../default_widget/dropdown_search.dart';
import '../../default_widget/pagination.dart';
import '../../models/item.dart';
import '../../router/router.dart';
import 'edit_item_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  var controller = Get.put(ItemController());

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
                        onChange: (value) async {
                          controller.fetchItems();
                          controller.update();
                        },
                        hintText: 'Tìm kiếm: Tên, Barcode',
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            height: 33,
                            width: 130,
                            alignment: Alignment.centerRight,
                            child: customText(text: 'Tồn kho:')),
                        StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return Checkbox(
                                value: controller.inStock,
                                onChanged: (value) {
                                  setState(() {
                                    controller.inStock = !controller.inStock;
                                    if(controller.inStock == true){
                                      controller.pageNumber = 1;
                                    }
                                    controller.update();
                                  });
                                });
                          },
                        ),
                      ],
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
                                  text: 'Tên mặt hàng',
                                  color: primaryColor,
                                  size: 16,
                                  weight: FontWeight.w600)),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 100,
                            child: customText(
                                text: 'Giá mua ',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 100,
                            child: customText(
                                text: 'Giá bán ',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: customText(
                                text: 'Tồn kho',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: customText(
                                text: 'Đơn vị',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 120,
                            child: customText(
                                text: 'BarCode',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
                          ),
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
                          builder: (ItemController controller) {
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
                                    return SelectionArea(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  controller.items.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                Item item =
                                                    controller.items[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
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
                                                                      text: item
                                                                              .Id
                                                                          .toString()))),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child: customText(
                                                                text: item
                                                                    .Name!)),
                                                        Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            width: 100,
                                                            child: customText(
                                                                text: formatMoney(
                                                                    item.PurchasePrice!))),
                                                        Container(
                                                            width: 100,
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: customText(
                                                                text: formatMoney(
                                                                    item.SalePrice!))),
                                                        Container(
                                                          width: 100,
                                                          alignment:
                                                              Alignment.center,
                                                          child: customText(
                                                              text: item.Stock
                                                                  .toString()),
                                                        ),
                                                        Container(
                                                            width: 100,
                                                            alignment: Alignment
                                                                .center,
                                                            child: customText(
                                                                text: item
                                                                    .unitDetails!
                                                                    .UnitName!)),
                                                        Container(
                                                            width: 120,
                                                            alignment: Alignment
                                                                .center,
                                                            child: customText(
                                                                text: item
                                                                    .BarCode!)),
                                                        IconButton(
                                                          onPressed: () {
                                                            Uri baseUri =
                                                                Uri.base;
                                                            String baseUrl =
                                                                '${baseUri.scheme}://${baseUri.host}:${baseUri.port}/#';
                                                            html.window.open(
                                                                '$baseUrl${editItemPage.router}?id=${item.Id}',
                                                                '_blank');
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            await controller
                                                                .btnRemoveOnClick(
                                                                    item.Id!);
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
                                                    controller.pageNumber =
                                                        page;
                                                    controller.update();
                                                  })
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
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: customTextFormField(
                    onChange: (value) async {
                      controller.fetchItems();
                      controller.update();
                    },
                    hintText: 'Tìm kiếm: Tên, Barcode',
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
                  height: 5,
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
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
                      Container(
                          width: 60,
                          alignment: Alignment.centerRight,
                          child: customText(text: 'Tồn kho:')),
                      StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Checkbox(
                              value: controller.inStock,
                              onChanged: (value) {
                                setState(() {
                                  controller.inStock = !controller.inStock;
                                  controller.update();
                                });
                              });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 650,
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
                                      text: 'Tên mặt hàng',
                                      color: primaryColor,
                                      size: 16,
                                      weight: FontWeight.w600)),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 100,
                                child: customText(
                                    text: 'Giá mua ',
                                    color: primaryColor,
                                    size: 16,
                                    weight: FontWeight.w600),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 100,
                                child: customText(
                                    text: 'Giá bán ',
                                    color: primaryColor,
                                    size: 16,
                                    weight: FontWeight.w600),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 80,
                                child: customText(
                                    text: 'Tồn kho',
                                    color: primaryColor,
                                    size: 16,
                                    weight: FontWeight.w600),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 70,
                                child: customText(
                                  text: 'Đơn vị',
                                  color: primaryColor,
                                  size: 16,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: GetBuilder(
                              builder: (ItemController controller) {
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
                                        return SelectionArea(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      controller.items.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    Item item =
                                                        controller.items[index];
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                                    .all(Radius
                                                                        .circular(
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
                                                                          text:
                                                                              item.Id.toString()))),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child: customText(
                                                                    text: item
                                                                        .Name!)),
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                width: 100,
                                                                child: customText(
                                                                    text: formatMoney(
                                                                        item.PurchasePrice!))),
                                                            Container(
                                                                width: 100,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: customText(
                                                                    text: formatMoney(
                                                                        item.SalePrice!))),
                                                            Container(
                                                              width: 80,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: customText(
                                                                  text: item
                                                                          .Stock
                                                                      .toString()),
                                                            ),
                                                            Container(
                                                                width: 70,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: customText(
                                                                    text: item
                                                                        .unitDetails!
                                                                        .UnitName!)),
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
                                                                            EditItemPage(
                                                                          item:
                                                                              item,
                                                                        ),
                                                                      ),
                                                                    ));
                                                              },
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await controller
                                                                    .btnRemoveOnClick(
                                                                        item.Id!);
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
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
                GetBuilder(
                  builder: (ItemController controller) {
                    return controller.totalPageItem == 1
                        ? Container()
                        : WebPagination(
                            currentPage: controller.pageNumber,
                            totalPage: controller.totalPageItem,
                            displayItemCount: 3,
                            onPageChanged: (page) {
                              controller.pageNumber = page;
                              controller.update();
                            });
                  },
                )
              ],
            ),
          );
  }
}
