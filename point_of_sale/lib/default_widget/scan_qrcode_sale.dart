import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../common.dart';
import '../controller/salePage/bill_sale_controller.dart';
import '../models/item.dart';
import 'custom_button.dart';
import 'custom_text.dart';

class ScanQrcodeSale extends StatefulWidget {
  const ScanQrcodeSale({super.key});

  @override
  State<ScanQrcodeSale> createState() => _ScanQrcodeSaleState();
}

class _ScanQrcodeSaleState extends State<ScanQrcodeSale> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(flex: 2, child: Container(child: _buildQrView(context))),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: customText(
                  text: 'Giỏ hàng',
                  size: 18,
                )),
                GetBuilder(
                  builder: (BillSaleController controller) {
                    var saleDetails = controller.billSale.saleDetails;
                    return saleDetails!.isEmpty
                        ? Expanded(
                            child: Center(
                                child: Container(
                            alignment: Alignment.center,
                            child: customText(text: 'Giỏ hàng trống'),
                          )))
                        : Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: saleDetails.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item = saleDetails[index];
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: SizedBox(
                                                  width: 20,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: customText(
                                                      text: (index + 1)
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: customText(
                                                      text:
                                                          '${item.ItemName}')),
                                              IconButton(
                                                  onPressed: () {
                                                    controller.removeItem(item);
                                                  },
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.red,
                                                  ))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              customButton(
                                                  text: '-',
                                                  onPressed: () {
                                                    item.Quantity =
                                                        item.Quantity! - 1;
                                                    if (item.Quantity == 0) {
                                                      saleDetails.remove(item);
                                                    }
                                                    controller.itemOnChanged();
                                                    controller.update();
                                                  }),
                                              SizedBox(
                                                  width: 40,
                                                  child: Center(
                                                      child: customText(
                                                          text: item.Quantity
                                                              .toString()))),
                                              customButton(
                                                  text: '+',
                                                  onPressed: () {
                                                    item.Quantity =
                                                        item.Quantity! + 1;
                                                    controller.itemOnChanged();
                                                    controller.update();
                                                  }),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: customText(
                                                          text: formatMoney(item
                                                                  .Quantity! *
                                                              item.Price!)))),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                controller.billSale.saleDetails!.isEmpty
                                    ? Container()
                                    : SizedBox(
                                        height: 40,
                                        child: customButton(
                                            text:
                                                'Thanh toán: ${formatMoney(controller.billSale.SaleAmount!)} VNĐ',
                                            onPressed: () async {
                                              Get.back();
                                              controller.btnPayOnClick(context);
                                            })),
                              ],
                            ),
                          );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        _onQRViewCreated(controller);
      },
      overlay: QrScannerOverlayShape(
        borderColor: primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300.0,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    BillSaleController billSaleController = Get.find();
    setState(() {
      this.controller = controller;
    });

    String? lastScannedCode;
    Timer? delayTimer;

    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      String currentCode = result?.code ?? '';

      // Nếu mã quét hiện tại giống với mã quét lần trước
      if (currentCode == lastScannedCode) {
        // Nếu có timer đang chạy thì hủy nó
        delayTimer?.cancel();

        // Khởi tạo một timer mới để delay 0.5 giây
        delayTimer = Timer(const Duration(milliseconds: 500), () async {
          // Thêm giá trị trùng lặp sau khi delay 0.5 giây
          Item item = await billSaleController.getItemByBarCode(currentCode);
          billSaleController.addItemToBill(item);
          billSaleController.update();
        });
      } else {
        // Nếu mã quét hiện tại khác với mã quét lần trước, xử lý ngay lập tức
        Item item = await billSaleController.getItemByBarCode(currentCode);
        billSaleController.addItemToBill(item);
        billSaleController.update();
      }
      // Cập nhật mã quét lần trước
      lastScannedCode = currentCode;
    });
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
