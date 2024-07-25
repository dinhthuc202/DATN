import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SizeController extends GetxController{
  static SizeController instance = Get.find();
  double height = 0;
  double width = 0;
  void getSize(BuildContext context){
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }
}