import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'controller/size_controller.dart';

const Color primaryColor = Color(0xFF1976D2);
const Color secondaryColor = Color(0xFFFFC107);
const Color buttonColor = Color(0xFF1976D2); // Màu cho các nút
const Color textButtonColor = Colors.white; // Màu cho văn bản chính
const Color textColor = Colors.black; // Màu cho văn bản chính
const Color backgroundColor = Colors.white; // Màu nền

SizeController sizeController = SizeController.instance;

//Convert
String formatMoney(double number) {
  try {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  } catch (e) {
    return 'Invalid number';
  }
}
DateTime? parseDate(String dateString) {
  try {
    DateFormat format = DateFormat('dd/MM/yyyy');
    return format.parse(dateString);
  } catch (e) {
    return null;
  }
}
String convertDate(DateTime date) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

//format input
List<TextInputFormatter> inputInt = [
  FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*|0$')),
];
MaskTextInputFormatter inputDate = MaskTextInputFormatter(mask: "##/##/####");
MaskTextInputFormatter inputPhone = MaskTextInputFormatter(mask: "##########");
String? validatorDate(String? value, {bool isRequired = false}) {
  if (!isRequired && (value == null || value.isEmpty)) {
    return null;
  }

  if (value == null || value.isEmpty) {
    return 'Vui lòng điền đầy đủ thông tin';
  }

  final components = value.split("/");
  if (components.length == 3) {
    final day = int.tryParse(components[0]);
    final month = int.tryParse(components[1]);
    final year = int.tryParse(components[2]);

    if (day != null && month != null && year != null) {
      if (year > 0 && month > 0 && month <= 12 && day > 0) {
        final date = DateTime(year, month, day);
        if (date.year == year && date.month == month && date.day == day) {
          return null;
        }
      }
    }
  }

  return "Ngày không hợp lệ";
}
String? validateEmail(String? value, {bool isRequired = false}) {
  if (!isRequired && (value == null || value.isEmpty)) {
    return null;
  }

  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập email';
  }

  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(value)) {
    return 'Email không hợp lệ';
  }

  return null;
}



