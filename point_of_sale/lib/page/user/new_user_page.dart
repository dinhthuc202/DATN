import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/controller/userPage/new_user_page_controller.dart';
import '../../common.dart';
import '../../default_widget/custom_button.dart';
import '../../default_widget/custom_text.dart';
import '../../default_widget/custom_textformfield.dart';
import '../../default_widget/dropdown_search.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({super.key});

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  NewUserPageController controller = Get.put(NewUserPageController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
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
                            width: 125,
                            child: customText(
                              text: 'Tài khoản:  ',
                            )),
                      ),
                      Expanded(
                        child: customTextFormField(
                          controller: controller.userNameController,
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
                            width: 125,
                            child: customText(
                              text: 'Mật khẩu:  ',
                            )),
                      ),
                      Expanded(
                        child: customTextFormField(
                          controller: controller.passwordController,
                          validator: (value) {
                            return controller.validatePassword(value);
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
                            width: 125,
                            child: customText(
                              text: 'Nhập lại mật khẩu:  ',
                            )),
                      ),
                      Expanded(
                        child: customTextFormField(
                          controller: controller.confirmPasswordController,
                          validator: (value) {
                            return controller.validateConfirmPassword(value);
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
                            width: 125,
                            child: customText(
                              text: 'Họ và tên:  ',
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
                            width: 125,
                            child: customText(
                              text: 'Ngày sinh:  ',
                            )),
                      ),
                      Expanded(
                        child: customTextFormField(
                          hintText: 'dd/MM/yyyy',
                          keyboardType: TextInputType.number,
                          inputFormatters: [inputDate],
                          controller: controller.birthdayController,
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
                            width: 125,
                            child: customText(
                              text: 'Số điện thoại:  ',
                            )),
                      ),
                      Expanded(
                        child: customTextFormField(
                          controller: controller.mobileController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [inputPhone],
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
                            width: 125,
                            child: customText(
                              text: 'Email:  ',
                            )),
                      ),
                      Expanded(
                        child: customTextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
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
                            width: 125,
                            child: customText(
                              text: 'Địa chỉ:  ',
                            )),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                            alignment: Alignment.centerRight,
                            width: 125,
                            child: customText(
                              text: 'Kiểu tài khoản:  ',
                            )),
                      ),
                      Expanded(
                        child: DropdownSearch(
                          textEditingController: controller.typeAccount,
                          labelText: 'Chọn kiểu tài khoản',
                          menuHeight: 200,
                          listItem: (int pageNumber, String filter) async {
                            return [
                              {'key': 'Admin', 'value': 'Admin'},
                              {'key': 'Manage', 'value': 'Manage'},
                              {'key': 'Cashier', 'value': 'Cashier'},
                            ];
                          },
                          onChange: (value) {
                            controller.user.TypeAccount = value['value'];
                          },
                          enableSearch: false,
                          enableLazyLoading: false,
                        ),
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
                          );
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
