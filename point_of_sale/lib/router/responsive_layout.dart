import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_html/html.dart' as html;
import '../common.dart';
import '../controller/user_controller.dart';
import '../page/login_page.dart';
import 'navigation_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'router.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final _link = LayerLink();
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: GetBuilder<NavigationController>(
          builder: (controller) {
            //Phương thức xác thực đăng nhập yêu cầu đăng nhập trước
            if (userController.isLoggedIn == false) {
              controller.changeScreen(authPage);
              return const LoginPage();
            }
            return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white, // Đặt màu cho icon drawer
                ),
                backgroundColor: primaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.screenActive.value.pageDisplayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    CompositedTransformTarget(
                      link: _link,
                      child: OverlayPortal(
                        controller: _tooltipController,
                        overlayChildBuilder: (BuildContext context) {
                          return CompositedTransformFollower(
                            link: _link,
                            offset: const Offset(-260, 0),
                            targetAnchor: Alignment.bottomLeft,
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: TapRegion(
                                onTapOutside: (tap) {
                                  _tooltipController.toggle();
                                },
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function())
                                        setState) {
                                      return Column(children: [
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: 25,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return const ListTile(
                                                title: Text('Pull down here'),
                                                subtitle: Text(
                                                    'RefreshIndicator will trigger'),
                                              );
                                            },
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: 'Làm mới',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  decoration:
                                                  TextDecoration.underline,
                                                  decorationColor: Colors
                                                      .blue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: InkWell(
                          onTap: () {
                            _tooltipController.toggle();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: badges.Badge(
                              badgeContent: Text(
                                '3',
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              drawer: myDrawer,
              body: Layout(
                widget: controller.showScreenActive(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({super.key, required this.widget});

  final Widget widget;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    sizeController.getSize(context);
    ScrollController controllerHorizontal = ScrollController();
    return Scrollbar(
        thumbVisibility: true,
        controller: controllerHorizontal,
        child: SingleChildScrollView(
          controller: controllerHorizontal,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: sizeController.width,
            child: widget.widget,
          ),
      ),
    );
  }
}
final box = GetStorage();
var myDrawer = Drawer(
  backgroundColor: Colors.grey[200],
  elevation: 0,
  child: SingleChildScrollView(
    child: Column(
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.account_circle,
                size: 64,
                color: Colors.blueGrey,
              ),
              Text(box.read('user')['name'] ?? 'N/A'),
            ],
          ),
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 17.0, right: 10, top: 5, bottom: 5),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 25,
                      maxHeight: 25,
                    ),
                    child: Image.asset("assets/images/home.png"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text('Trang chủ'),
                ),
              ],
            ),
          ),
          onTap: () {
            Get.offAllNamed('/');
          },
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: listButtonMenu
              .map((i) => Column(
            children: [
              ExpansionTile(
                leading: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 25,
                    maxHeight: 25,
                  ),
                  child: i.ic,
                ),
                title: Text(i.name),
                children: i.itm
                    .map((e) => Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ListTile(
                    title: Text(e.pageDisplayName),
                    onTap: () {
                      if (e.router == authPage.router) {
                        // Get.offAll(
                        //     const AuthenticationPage());
                        // return;
                      }
                      Uri baseUri = Uri.base;
                      String baseUrl =
                          '${baseUri.scheme}://${baseUri.host}:${baseUri.port}/#';
                      html.window.history.pushState(null,
                          e.pageDisplayName, baseUrl + e.router);
                      navigationController.changeScreen(e);
                      navigationController.update();
                    },
                  ),
                ))
                    .toList(),
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
            ],
          ))
              .toList(),
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 17.0, right: 10, top: 5, bottom: 5),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 25,
                      maxHeight: 25,
                    ),
                    child: Image.asset("assets/images/sign_out.png"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text('Đăng xuất'),
                ),
              ],
            ),
          ),
          onTap: () {
            UserController controller = Get.find();
            controller.signOut();
          },
        ),
      ],
    ),
  ),
);

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

class DauMucItems {
  final String name;
  final List<ScreenActive> itm;
  final Image ic;

  DauMucItems(this.name, this.itm, this.ic);
}
