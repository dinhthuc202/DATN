import 'package:flutter/material.dart';

import '../../api.dart';
import '../../models/item.dart';
import 'new_item_page.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({
    super.key,
    this.item,
  });

  final Item? item;

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  int? itemId;
  Item? item;

  @override
  void initState() {
    super.initState();
    if (widget.item == null) {
      getDataFromUrl(Uri.base.fragment.toString());
    }
  }

  void getDataFromUrl(String url) {
    if (!url.contains('?')) {
      return;
    }
    itemId = int.parse(Uri.parse(url).queryParameters['id']!);
  }

  Future fetchData() async {
    item = await Api.getItem(itemId: itemId!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      return FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            //return Text(item!.toJson().toString());
            return NewItemPage(
              item: item,
            );
          }
          return Container();
        },
      );
    }
    return NewItemPage(
      item: widget.item,
    );
  }
}
