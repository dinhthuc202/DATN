import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextFormField({
  FocusNode? focusNode,
  required TextEditingController controller,
  Function? onChange,
  Function? onEditingComplete,
  Function? validator,
  String? labelText,
  String? hintText,
  EdgeInsets? contentPadding,
  Widget? prefixIcon,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  int? maxLines = 1,
  int? minLines,
  bool? readOnly,
  AutovalidateMode? autoValidateMode,
}) {
  return TextFormField(
    focusNode: focusNode,
    onEditingComplete: () async{
      if (onEditingComplete != null) {
        await onEditingComplete();
      }
    },
    autovalidateMode: autoValidateMode,
    style: const TextStyle(fontSize: 14),
    readOnly: readOnly ?? false,
    maxLines: maxLines,
    minLines: minLines,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    onChanged: (value) {
      if (onChange != null) {
        onChange(value);
      }
    },
    validator: (value) {
      if (validator != null) {
        return validator(value);
      } else {
        return null;
      }
    },
    controller: controller,
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      isDense: true,
      contentPadding: contentPadding ?? const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 9),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w300, color: Colors.grey),
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 14,
      ),
      prefixIcon: prefixIcon,
    ),
  );
}
