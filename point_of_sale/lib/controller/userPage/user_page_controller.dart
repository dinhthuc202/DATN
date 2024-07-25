import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/models/user.dart';
import '../../api.dart';

class UserPageController extends GetxController{
  List<User> users = [];
  TextEditingController filter = TextEditingController();
  int totalPageItem = 1;
  int pageNumber = 1;
  bool sortByNewest = false;

  String groupSelected = "";

  Future<void> fetchUsers() async {
    users = await Api.getUsers(filter.text,groupSelected);
  }
}