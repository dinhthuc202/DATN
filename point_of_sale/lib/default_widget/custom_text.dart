import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/common.dart';

Widget customText({
  required String text,
  double? size,
  Color? color,
  FontWeight? weight,
  int? maxLine,
  bool? softWrap,
}) {
  return Text(
    text,
    softWrap: softWrap,
    maxLines: maxLine ?? 2,
    style: TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: size ?? 14,
      color: color ?? textColor,
      fontWeight: weight ?? FontWeight.normal,
      decoration: TextDecoration.none,
    ),
  );
}
