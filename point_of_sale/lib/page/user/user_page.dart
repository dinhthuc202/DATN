import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common.dart';
import '../../controller/userPage/user_page_controller.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import '../../default_widget/dropdown_search.dart';
import '../../default_widget/pagination.dart';
import '../../models/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var controller = Get.put(UserPageController());
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 900 ? Padding(
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
                    controller.fetchUsers();
                    controller.update();
                  },
                  hintText: 'Tên, SĐT, Email, Username',
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
                  labelText: 'Kiểu tài khoản',
                  itemDefault: 'Tất cả',
                  menuHeight: 200,
                  listItem: (int pageNumber, String filter) async {
                    return [
                      {'key': '', 'value': 'Tất cả'},
                      {'key': 'Admin', 'value': 'Admin'},
                      {'key': 'Manage', 'value': 'Manage'},
                      {'key': 'Cashier', 'value': 'Cashier'},
                    ];
                  },
                  onChange: (value) {
                    controller.groupSelected = value['key'];
                    controller.update();
                  },
                  enableSearch: false,
                  enableLazyLoading: false,
                ),
              ),
              const SizedBox(
                height: 5,
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
                            text: 'Username',
                            color: primaryColor,
                            size: 16,
                            weight: FontWeight.w600)),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: customText(
                            text: 'Tên người dùng',
                            color: primaryColor,
                            size: 16,
                            weight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: customText(
                            text: 'Email',
                            color: primaryColor,
                            size: 16,
                            weight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      child: customText(
                          text: 'Số điện thoại',
                          color: primaryColor,
                          size: 16,
                          weight: FontWeight.w600),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 110,
                      child: customText(
                          text: 'Kiểu tài khoản',
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
                    builder: (UserPageController controller) {
                      return FutureBuilder(
                          future: controller.fetchUsers(),
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
                                        itemCount: controller.users.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          User user = controller.users[index];
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
                                                  const BorderRadius.all(
                                                      Radius.circular(8))),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(5),
                                                    child: SizedBox(
                                                        width: 40,
                                                        child: Center(
                                                            child: customText(
                                                                maxLine: 1,
                                                                text: user.Id
                                                                    .toString()))),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: customText(
                                                          text:
                                                          user.UserName!)),
                                                  Expanded(
                                                    child: Container(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        child: customText(
                                                            text: user.Name!)),
                                                  ),

                                                  Expanded(
                                                    child: Container(
                                                      alignment: Alignment.centerLeft,
                                                      child: customText(
                                                          text: user.Email!),
                                                    ),
                                                  ),
                                                  Container(
                                                      width: 100,
                                                      alignment: Alignment.center,
                                                      child: customText(
                                                          text: user.Mobile!.trim())),
                                                  Container(
                                                      width: 110,
                                                      alignment:
                                                      Alignment.center,
                                                      child: customText(
                                                          text: user
                                                              .TypeAccount!)),
                                                  IconButton(
                                                    onPressed: () {
                                                      // Uri baseUri = Uri.base;
                                                      // String baseUrl =
                                                      //     '${baseUri
                                                      //     .scheme}://${baseUri
                                                      //     .host}:${baseUri
                                                      //     .port}/#';
                                                      // html.window.open(
                                                      //     '$baseUrl${editItemPage
                                                      //         .router}?id=${item
                                                      //         .Id}',
                                                      //     '_blank');
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      // await controller
                                                      //     .btnRemoveOnClick(
                                                      //     item.Id!);
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
                                        currentPage: controller.pageNumber,
                                        totalPage: controller.totalPageItem,
                                        displayItemCount: 5,
                                        onPageChanged: (page) {
                                          controller.pageNumber = page;
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
    ) :
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: customTextFormField(
              onChange: (value) async {
                controller.fetchUsers();
                controller.update();
              },
              hintText: 'Tên, SĐT, Email, Username',
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
              labelText: 'Kiểu tài khoản',
              itemDefault: 'Tất cả',
              menuHeight: 200,
              listItem: (int pageNumber, String filter) async {
                return [
                  {'key': '', 'value': 'Tất cả'},
                  {'key': 'Admin', 'value': 'Admin'},
                  {'key': 'Manage', 'value': 'Manage'},
                  {'key': 'Cashier', 'value': 'Cashier'},
                ];
              },
              onChange: (value) {
                controller.groupSelected = value['key'];
                controller.update();
              },
              enableSearch: false,
              enableLazyLoading: false,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 460,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: customText(
                                  text: 'Username',
                                  color: primaryColor,
                                  size: 16,
                                  weight: FontWeight.w600)),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: customText(
                                      text: 'Tên người dùng',
                                      color: primaryColor,
                                      size: 16,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 110,
                            child: customText(
                                text: 'Kiểu tài khoản',
                                color: primaryColor,
                                size: 16,
                                weight: FontWeight.w600),
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
                          builder: (UserPageController controller) {
                            return FutureBuilder(
                                future: controller.fetchUsers(),
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
                                              itemCount: controller.users.length,
                                              itemBuilder:
                                                  (BuildContext context, int index) {
                                                User user = controller.users[index];
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
                                                        const BorderRadius.all(
                                                            Radius.circular(8))),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                            child: customText(
                                                                text:
                                                                user.UserName!)),
                                                        Expanded(
                                                          child: Container(
                                                              alignment:
                                                              Alignment.centerLeft,
                                                              child: customText(
                                                                  text: user.Name!)),
                                                        ),
                                                        Container(
                                                            width: 110,
                                                            alignment:
                                                            Alignment.center,
                                                            child: customText(
                                                                text: user
                                                                    .TypeAccount!)),
                                                        IconButton(
                                                          onPressed: () {
                                                            // Uri baseUri = Uri.base;
                                                            // String baseUrl =
                                                            //     '${baseUri
                                                            //     .scheme}://${baseUri
                                                            //     .host}:${baseUri
                                                            //     .port}/#';
                                                            // html.window.open(
                                                            //     '$baseUrl${editItemPage
                                                            //         .router}?id=${item
                                                            //         .Id}',
                                                            //     '_blank');
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            // await controller
                                                            //     .btnRemoveOnClick(
                                                            //     item.Id!);
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
                                              currentPage: controller.pageNumber,
                                              totalPage: controller.totalPageItem,
                                              displayItemCount: 5,
                                              onPageChanged: (page) {
                                                controller.pageNumber = page;
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
