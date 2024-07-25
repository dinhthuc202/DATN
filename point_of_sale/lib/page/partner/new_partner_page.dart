import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common.dart';
import '../../controller/partnerPage/newPartner_controller.dart';
import '../../default_widget/custom_button.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import '../../default_widget/dropdown_search.dart';
import '../../models/customer.dart';
import '../../models/supplier.dart';

class NewPartnerPage extends StatefulWidget {
  const NewPartnerPage(
      {super.key, this.isSupplier, this.customer, this.supplier});

  final Supplier? supplier;
  final Customer? customer;
  final bool? isSupplier;

  @override
  State<NewPartnerPage> createState() => _NewPartnerPageState();
}

class _NewPartnerPageState extends State<NewPartnerPage> {
  NewPartnerPageController controller =
      Get.put(NewPartnerPageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSupplier != null) {
      controller.isSupplier = widget.isSupplier!;
      if (widget.isSupplier == true) {
        controller.fetchDataEdit(partner: widget.supplier!);
      } else {
        controller.fetchDataEdit(partner: widget.customer!);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: controller.formKey,
        child: MediaQuery.of(context).size.width > 900
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SizedBox(
                      width: 230,
                      height: 40,
                      child: DropdownSearch(
                        readOnly: widget.isSupplier != null ? true : false,
                        labelText: 'Loại đối tác',
                        itemDefault: widget.isSupplier == null ? 'Nhà cung cấp' : widget.isSupplier == true ?'Nhà cung cấp': 'Khách hàng',
                        menuHeight: 120,
                        listItem: (int pageNumber, String filter) async {
                          return [
                            {'value': 'Nhà cung cấp', 'id': true},
                            {'value': 'Khách hàng', 'id': false},
                          ];
                        },
                        onChange: (value) {
                          controller.isSupplier = value['id'];
                        },
                        enableSearch: false,
                        enableLazyLoading: false,
                      ),
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
                              width: 100,
                              child: customText(
                                text: 'Tên đối tác:  ',
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
                        const Expanded(child: SizedBox()),
                        const SizedBox(
                          width: 150,
                        ),
                      ],
                    ),
                  ),
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
                                        child:
                                            customText(text: 'Ngày sinh:  ')),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                      hintText: 'dd/MM/yyyy',
                                      inputFormatters: [inputDate],
                                      controller: controller.birthdayController,
                                      validator: (value) {
                                        return validatorDate(value,
                                            isRequired: true);
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
                                      child: customText(text: 'Địa chỉ:  '),
                                    ),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                      controller: controller.addressController,
                                      validator: (value) {
                                        return controller
                                            .validatorAction(value);
                                      },
                                    ),
                                  ),
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
                                    child: SizedBox(
                                        width: 100,
                                        child: customText(
                                            text: 'Số điện thoại:  ')),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                      inputFormatters: [inputPhone],
                                      controller: controller.phoneController,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: customText(text: 'Email:  ')),
                                  ),
                                  Expanded(
                                    child: customTextFormField(
                                        validator: (value) {
                                          return validateEmail(value,
                                              isRequired: false);
                                        },
                                        controller: controller.emailController),
                                  ),
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
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            width: 100,
                            child: customText(text: 'Ghi chú:  ')),
                        Expanded(
                          child: customTextFormField(
                              minLines: 2,
                              maxLines: 5,
                              controller: controller.descriptionController),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        const SizedBox(
                          width: 150,
                        )
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 160,
                      child: customButton(
                          text: widget.isSupplier != null ? 'Sửa' : 'Thêm mới',
                          onPressed: () async {
                            await controller.btnAddOnCLick(context,
                                isEdit: widget.isSupplier != null);
                          }),
                    ),
                  )
                ],
              )
            : SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      SizedBox(
                        height: 40,
                        child: DropdownSearch(
                          readOnly: widget.isSupplier == null ? false : true,
                          labelText: 'Loại đối tác',
                          itemDefault: widget.isSupplier == null ? 'Nhà cung cấp' : widget.isSupplier == true ?'Nhà cung cấp': 'Khách hàng',
                          menuHeight: 120,
                          listItem: (int pageNumber, String filter) async {
                            return [
                              {'value': 'Nhà cung cấp', 'id': true},
                              {'value': 'Khách hàng', 'id': false},
                            ];
                          },
                          onChange: (value) {
                            controller.isSupplier = value['id'];
                          },
                          enableSearch: false,
                          enableLazyLoading: false,
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
                                  width: 100,
                                  child: customText(
                                    text: 'Tên đối tác:  ',
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                                alignment: Alignment.centerRight,
                                width: 100,
                                child: customText(text: 'Ngày sinh:  ')),
                          ),
                          Expanded(
                            child: customTextFormField(
                              hintText: 'dd/MM/yyyy',
                              inputFormatters: [inputDate],
                              keyboardType: TextInputType.number,
                              controller: controller.birthdayController,
                              validator: (value) {
                                return validatorDate(value, isRequired: true);
                              },
                            ),
                          ),
                        ],
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
                                width: 100,
                                child: customText(text: 'Địa chỉ:  '),
                              ),
                            ),
                            Expanded(
                              child: customTextFormField(
                                controller: controller.addressController,
                                validator: (value) {
                                  return controller.validatorAction(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                        child: SizedBox(
                                            width: 100,
                                            child: customText(
                                                text: 'Số điện thoại:  ')),
                                      ),
                                      Expanded(
                                        child: customTextFormField(
                                          inputFormatters: [inputPhone],
                                          keyboardType: TextInputType.phone,
                                          controller: controller.phoneController,
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            width: 100,
                                            child: customText(text: 'Email:  ')),
                                      ),
                                      Expanded(
                                        child: customTextFormField(
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (value) {
                                              return validateEmail(value,
                                                  isRequired: false);
                                            },
                                            controller: controller.emailController),
                                      ),
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
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                width: 100,
                                child: customText(text: 'Ghi chú:  ')),
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
                              text: widget.isSupplier != null ? 'Sửa' : 'Thêm mới',
                              onPressed: () async {
                                await controller.btnAddOnCLick(context,
                                    isEdit: widget.isSupplier != null);
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
