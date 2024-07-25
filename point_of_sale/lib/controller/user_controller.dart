import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../api.dart';

class UserController extends GetxController{
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();
  bool isLoggedIn = false;
  bool rememberMe = false;
  String username = '';
  String password = '';

  Future<void> login() async {
    Get.dialog(const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        )));
    final url = "$urlApi/api/Login";
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userName': username,
        'password': password,
      }),
    );
    Get.back();
    if (response.statusCode == 200) {
      isLoggedIn = true;
      if(rememberMe == true){
        box.write('userName', username);
        box.write('password', password);
      }
      //box.write('jwt_token', json.decode(response.body)['token']);
      box.write('user', json.decode(response.body));
      Get.offAllNamed('/');
    } else if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sai tài khoản hoặc mật khẩu');
    } else {
      Get.snackbar('Error', 'Vui lòng nhập đầy đủ thông tin.');
    }
  }

  void signOut() {
    box.remove('userName');
    box.remove('password');
    //box.remove('jwt_token');
    isLoggedIn = false;
    Get.offAllNamed('/');
  }

  Future<void> checkLogin() async {
    if(box.read('userName') == null || box.read('password') == null ){
      return;
    }
    username = box.read('userName');
    password = box.read('password');
    final url = "$urlApi/api/Login";
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userName': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      isLoggedIn = true;
      ///----------------
     // box.write('jwt_token', json.decode(response.body)['token']);
      box.write('user', json.decode(response.body));
    } else if (response.statusCode == 401) {
      isLoggedIn = false;
    }
  }
  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(box.read('jwt_token'));
  }

  Future<void>checkTokenExpired() async{

  }
}