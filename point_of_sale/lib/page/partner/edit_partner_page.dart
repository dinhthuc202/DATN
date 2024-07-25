import 'package:flutter/material.dart';
import '../../api.dart';
import '../../models/customer.dart';
import '../../models/supplier.dart';
import 'new_partner_page.dart';

class EditPartnerPage extends StatefulWidget {
  const EditPartnerPage({super.key, this.isSupplier, this.supplier, this.customer});

  final bool? isSupplier;
  final Supplier? supplier;
  final Customer? customer;

  @override
  State<EditPartnerPage> createState() => _EditPartnerPageState();
}

class _EditPartnerPageState extends State<EditPartnerPage> {
  int? id;
  bool? isSupplier;
  Supplier? supplier;
  Customer? customer;

  @override
  void initState() {
    super.initState();
    if (widget.isSupplier == null) {
      getDataFromUrl(Uri.base.fragment.toString());
    }
  }

  void getDataFromUrl(String url) {
    if (!url.contains('?')) {
      return;
    }
    id = int.parse(Uri.parse(url).queryParameters['id']!);
    isSupplier = bool.parse(Uri.parse(url).queryParameters['isSupplier']!);
  }

  Future fetchData() async {
      if (isSupplier!) {
        supplier = await Api.getSupplier(supplierId: id!);
      } else {
        customer = await Api.getCustomer(customerId: id!);
      }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isSupplier == null){
      return FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return NewPartnerPage(
                isSupplier: isSupplier,
                supplier: supplier,
                customer: customer,
              );
            }
            return Container();
          });
    }
    return NewPartnerPage(
      isSupplier: widget.isSupplier,
      supplier: widget.supplier,
      customer: widget.customer,
    );
  }
}
