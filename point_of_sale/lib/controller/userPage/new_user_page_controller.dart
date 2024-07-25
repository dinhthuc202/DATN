import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../../api.dart';
import '../../models/user.dart';

class NewUserPageController extends GetxController {
  final formKey = GlobalKey<FormState>();
  User user = User();
  bool btnAddClick = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController typeAccount = TextEditingController();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    } else if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    } else if (value != passwordController.text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  String? validatorAction(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập đẩy đủ thông tin';
    }
    return null;
  }

  Future btnAddOnCLick(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      bool? success;
      final box = GetStorage();
      user.UserName = userNameController.text;
      user.Password = passwordController.text;
      user.Name = nameController.text;
      user.BirthDay = DateFormat('dd/MM/yyyy').parse(birthdayController.text);
      user.Mobile = mobileController.text;
      user.Email = emailController.text;
      user.Address = addressController.text;
      user.CreateBy =box.read('user')['userName'];
      success = await Api.register(user: user);
      if (success == true) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Thêm thành công',
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      } else if (success == null) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Tài khoản đã tồn tại',
          //autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Thêm không thành công',
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
        );
      }
    }
  }
}
