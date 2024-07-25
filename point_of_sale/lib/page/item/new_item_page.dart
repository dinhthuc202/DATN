import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/common.dart';
import '../../controller/itemPage/newItem_controller.dart';
import '../../default_widget/custom_button.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import '../../default_widget/dropdown_search.dart';
import '../../default_widget/scan_qrcode.dart';
import '../../models/item.dart';

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key, this.item});

  final Item? item;

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  NewItemController controller = Get.put(NewItemController());

  @override
  Widget build(BuildContext context) {
    if (widget.item != null) {
      controller.fetchDataEdit(itemInput: widget.item!);
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: controller.formKey,
        child: MediaQuery.of(context).size.width > 900
            ?
            //desktop
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: customText(
                                          text: 'Tên hàng:  ',
                                        )),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                      controller: controller.nameController,
                                      validator: (value) {
                                        return controller
                                            .validatorAction(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: customText(text: 'Giá mua:  ')),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: controller.purchaseController,
                                      validator: (value) {
                                        return controller
                                            .validatorAction(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: customText(text: 'Nhóm hàng: ')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: SizedBox(
                                      width: 250,
                                      height: 40,
                                      child: DropdownSearch(
                                        textEditingController:
                                            controller.groupController,
                                        labelText: 'Nhóm hàng',
                                        menuHeight: 200,
                                        listItem: (int pageNumber,
                                            String filter) async {
                                          return await controller.fetchGroups();
                                        },
                                        onChange: (value) {
                                          controller.item.GroupId =
                                              value['groupId'];
                                        },
                                        enableSearch: false,
                                        enableLazyLoading: false,
                                      ),
                                    ),
                                  ),
                                  GetBuilder(
                                    builder: (NewItemController controller) {
                                      return controller.btnAddClick == true &&
                                              controller.item.GroupId == null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0, left: 5),
                                              child: customText(
                                                  text:
                                                      'Vui lòng chọn nhóm hàng!',
                                                  color: Colors.red),
                                            )
                                          : Container();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: customText(
                                          text: 'Tồn kho:  ',
                                        )),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                      controller: controller.stockController,
                                      validator: (value) {
                                        return controller
                                            .validatorAction(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 100,
                                      child: customText(text: 'Giá bán:  '),
                                    ),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                      controller:
                                          controller.salePriceController,
                                      validator: (value) {
                                        return controller
                                            .validatorAction(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: customText(text: 'Đơn vị: ')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: SizedBox(
                                      width: 250,
                                      height: 40,
                                      child: DropdownSearch(
                                        textEditingController:
                                            controller.unitController,
                                        labelText: 'Đơn vị',
                                        menuHeight: 200,
                                        listItem: (int pageNumber,
                                            String filter) async {
                                          return await controller.fetchUnits();
                                        },
                                        onChange: (value) {
                                          controller.item.UnitId =
                                              value['unitId'];
                                        },
                                        enableSearch: false,
                                        enableLazyLoading: false,
                                      ),
                                    ),
                                  ),
                                  GetBuilder(
                                    builder: (NewItemController controller) {
                                      return controller.btnAddClick == true &&
                                              controller.item.UnitId == null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0, left: 5),
                                              child: customText(
                                                  text: 'Vui lòng chọn đơn vị!',
                                                  color: Colors.red),
                                            )
                                          : Container();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                              alignment: Alignment.centerRight,
                              width: 100,
                              child: customText(text: 'BarCode:  ')),
                        ),
                        Expanded(
                          child: customTextFormField(
                              validator: (value) {
                                return controller.validatorAction(value);
                              },
                              controller: controller.barCodeController),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                              alignment: Alignment.centerRight,
                              width: 100,
                              child: customText(text: 'Ghi chú:  ')),
                        ),
                        Expanded(
                          child: customTextFormField(
                              minLines: 2,
                              maxLines: 5,
                              controller: controller.descriptionController),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 160,
                      child: customButton(
                          text: widget.item == null ? 'Thêm mới' : 'Sửa',
                          onPressed: () async {
                            await controller.btnAddOnCLick(context,
                                isEdit: widget.item != null);
                            controller.update();
                          }),
                    ),
                  )
                ],
              )
            :
            //mobile
            SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 80,
                                  child: customText(
                                    text: 'Tên hàng:  ',
                                  )),
                            ),
                            Expanded(
                              child: customTextFormField(
                                controller: controller.nameController,
                                validator: (value) {
                                  return controller.validatorAction(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 80,
                                  child: customText(
                                    text: 'Giá mua:  ',
                                  )),
                            ),
                            Expanded(
                              child: customTextFormField(
                                inputFormatters: inputInt,
                                keyboardType: TextInputType.number,
                                controller: controller.purchaseController,
                                validator: (value) {
                                  return controller.validatorAction(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: 80,
                                child: customText(text: 'Giá bán:  '),
                              ),
                            ),
                            Expanded(
                              child: customTextFormField(
                                inputFormatters: inputInt,
                                keyboardType: TextInputType.number,
                                controller: controller.salePriceController,
                                validator: (value) {
                                  return controller.validatorAction(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 80,
                                  child: customText(text: 'Nhóm hàng: ')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: SizedBox(
                                width: 250,
                                height: 50,
                                child: DropdownSearch(
                                  textEditingController:
                                      controller.groupController,
                                  labelText: 'Nhóm hàng',
                                  menuHeight: 200,
                                  listItem:
                                      (int pageNumber, String filter) async {
                                    return await controller.fetchGroups();
                                  },
                                  onChange: (value) {
                                    controller.item.GroupId = value['groupId'];
                                  },
                                  enableSearch: false,
                                  enableLazyLoading: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GetBuilder(
                        builder: (NewItemController controller) {
                          return controller.btnAddClick == true &&
                                  controller.item.GroupId == null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 80.0),
                                  child: customText(
                                      text: 'Vui lòng chọn nhóm hàng!',
                                      color: Colors.red),
                                )
                              : Container();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 80,
                                  child: customText(
                                    text: 'Tồn kho:  ',
                                  )),
                            ),
                            Expanded(
                              child: customTextFormField(
                                inputFormatters: inputInt,
                                keyboardType: TextInputType.number,
                                controller: controller.stockController,
                                validator: (value) {
                                  return controller.validatorAction(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 80,
                                  child: customText(text: 'Đơn vị: ')),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: SizedBox(
                                width: 250,
                                height: 50,
                                child: DropdownSearch(
                                  textEditingController:
                                      controller.unitController,
                                  labelText: 'Đơn vị',
                                  menuHeight: 200,
                                  listItem:
                                      (int pageNumber, String filter) async {
                                    return await controller.fetchUnits();
                                  },
                                  onChange: (value) {
                                    controller.item.UnitId = value['unitId'];
                                  },
                                  enableSearch: false,
                                  enableLazyLoading: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GetBuilder(
                        builder: (NewItemController controller) {
                          return controller.btnAddClick == true &&
                                  controller.item.UnitId == null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 80),
                                  child: customText(
                                      text: 'Vui lòng chọn đơn vị!',
                                      color: Colors.red),
                                )
                              : Container();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 80,
                                  child: customText(text: 'BarCode:  ')),
                            ),
                            Expanded(
                              child: customTextFormField(
                                  validator: (value) {
                                    return controller.validatorAction(value);
                                  },
                                  controller: controller.barCodeController),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.dialog(ScanQrcode(
                                    textEditingController:
                                        controller.barCodeController,
                                  ));
                                },
                                icon: const Icon(
                                  Icons.qr_code_scanner,
                                  color: primaryColor,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 80,
                                  child: customText(text: 'Ghi chú:  ')),
                            ),
                            Expanded(
                              child: customTextFormField(
                                  minLines: 2,
                                  maxLines: 5,
                                  controller: controller.descriptionController),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 160,
                          child: customButton(
                              text: 'Thêm mới',
                              onPressed: () async {
                                await controller.btnAddOnCLick(context,
                                    isEdit: false);
                                controller.update();
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
