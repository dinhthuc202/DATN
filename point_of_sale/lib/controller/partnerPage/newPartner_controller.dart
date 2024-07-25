import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/api.dart';
import 'package:quickalert/quickalert.dart';
import '../../common.dart';
import '../../models/customer.dart';
import '../../models/supplier.dart';

class NewPartnerPageController extends GetxController {
  bool isSupplier = true;
  final formKey = GlobalKey<FormState>();

  int? idPartner;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  String? validatorAction(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập đẩy đủ thông tin';
    }
    return null;
  }

  Future btnAddOnCLick(BuildContext context, {required bool isEdit}) async {
    if (formKey.currentState?.validate() ?? false) {
      bool success = false;
      if (isSupplier) {
        Supplier supplier = Supplier(
          Id: idPartner,
          Name: nameController.text,
          Address: addressController.text,
          Birthday: DateFormat('dd/MM/yyyy').parse(birthdayController.text),
          Email: emailController.text == '' ? null : emailController.text,
          Phone: phoneController.text,
          Description: descriptionController.text == ''
              ? null
              : descriptionController.text,
        );
        //success lưu kết quả của api trả về
        success = isEdit == true
            ? await Api.updateSupplier(supplier: supplier) // isEdit == true
            : await Api.addSupplier(supplier: supplier); // isEdit == false
      } else {
        Customer customer = Customer(
          Id: idPartner,
          Name: nameController.text,
          Address: addressController.text,
          Birthday: DateFormat('dd/MM/yyyy').parse(birthdayController.text),
          Email: emailController.text == '' ? null : emailController.text,
          Phone: phoneController.text,
          Description: descriptionController.text == ''
              ? null
              : descriptionController.text,
        );
        //success lưu kết quả của api trả về
        success = isEdit == true
            ? await Api.updateCustomer(customer: customer) // isEdit == true
            : await Api.addCustomer(customer: customer); // isEdit == false
      }
      if (success) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: isEdit == true ? 'Cập nhật thành công' : 'Thêm thành công',
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: isEdit == true
              ? 'Cập nhật không thành công'
              : 'Thêm không thành công',
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
        );
      }
    }
  }

  void fetchDataEdit({dynamic partner}) {
    idPartner = partner.Id;
    nameController.text = partner.Name ?? '';
    addressController.text = partner.Address ?? '';
    if (partner.Birthday != null && partner.Birthday != "") {
      birthdayController.text = convertDate(partner.Birthday as DateTime);
    }
    emailController.text = partner.Email ?? '';
    phoneController.text = partner.Phone ?? '';
    descriptionController.text = partner.Description ?? '';
  }
}
