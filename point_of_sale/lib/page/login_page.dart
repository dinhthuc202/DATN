import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';
import '../default_widget/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    UserController controller = Get.find();
    bool obscureText = true;
    TextEditingController userNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    void showPass() {
      obscureText = !obscureText;
    }

    return Center(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: 900,
        height: 600,
        child: Row(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (MediaQuery.of(context).size.width > 900) {
                  return SizedBox(
                    width: 500,
                    child: Image.asset(
                      'assets/images/image_login.png',
                      fit: BoxFit.scaleDown,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            customText(
                              text: 'Đăng nhập',
                              size: 50,
                              color: Colors.blueAccent,
                              weight: FontWeight.bold,
                            ),
                            customText(
                              text: 'Chào mừng quay trở lại',
                              size: 17,
                              color: Colors.grey,
                              weight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        onChanged: (value) {
                          controller.username = value;
                        },
                        controller: userNameController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: "Tài khoản",
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 45,
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return TextFormField(
                            onChanged: (value) {
                              controller.password = value;
                            },
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "Mật khẩu",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showPass();
                                  });
                                },
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.lock),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return Checkbox(
                                  side: const BorderSide(
                                    color: Colors.blueAccent,
                                    // Màu viền tùy chỉnh
                                    width: 1.0, // Độ rộng của viền
                                  ),
                                  activeColor: Colors.blueAccent,
                                  value: controller.rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      controller.rememberMe =
                                          !controller.rememberMe;
                                    });
                                  });
                            },
                          ),
                          customText(
                            text: 'Lưu đăng nhập',
                            weight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.blueAccent),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await controller.login();
                        },
                        child: customText(
                          text: 'Đăng nhập',
                          color: Colors.white,
                          weight: FontWeight.w500,
                          size: 17,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
