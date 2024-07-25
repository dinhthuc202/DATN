import 'package:flutter/material.dart';
import 'package:point_of_sale/common.dart';
import 'package:point_of_sale/default_widget/custom_text.dart';

Widget customButton({
  required String text,
  required Function() onPressed,
  Color? color,
  BorderRadius? borderRadius,
  Color? textColor,
  double? textSize,
  FontWeight? weight,
}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(color ?? buttonColor),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
      ),
      child: Center(
        child: customText(
            text: text,
            color: textColor ?? textButtonColor,
            size: textSize ?? 14,
            weight: weight),
      ));
}
