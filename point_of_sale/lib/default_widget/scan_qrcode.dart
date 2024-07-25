import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/common.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrcode extends StatefulWidget {
   const ScanQrcode ({super.key, required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  State<StatefulWidget> createState() => _ScanQrcodeState();
}

class _ScanQrcodeState extends State<ScanQrcode> {
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
      child: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller){
        _onQRViewCreated(controller,widget.textEditingController);
      },
      overlay: QrScannerOverlayShape(
          borderColor: primaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300.0),
    );
  }

  void _onQRViewCreated(QRViewController controller, TextEditingController textEditingController) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        textEditingController.text = result?.code ?? '';
      });
      Get.back();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
