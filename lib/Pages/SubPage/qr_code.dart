import 'dart:io';
import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Pages/login.dart';
import 'package:eip_test/Tools/globals.dart' as globals;
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:console/console.dart' as console;
import 'dart:convert';
import 'dart:typed_data';
import 'package:steel_crypt/steel_crypt.dart';

class QRCodeData {
  String key;
  String iv;
  String encrypted;

  QRCodeData({
    required this.key,
    required this.iv,
    required this.encrypted,
  });

  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      key: json['key'],
      iv: json['iv'],
      encrypted: json['encrypted'],
    );
  }
}

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => QrCodeState();
}

class QrCodeState extends State<QrCode> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("QR Code"),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context, "not connected");
              },
              icon: const Icon(Icons.arrow_back),
            ),
            automaticallyImplyLeading: false,
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQrView(context),
              Positioned(bottom: 10, child: buildResult()),
            ],
          ),
        ),
      );

  Widget buildResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MyColor().myOrange,
        ),
        child: Text(
          barcode != null
              ? 'Result : ${decrypt(barcode!.code.toString())}'
              : 'Scan a code!',
          maxLines: 3,
          style: TextStyle(color: MyColor().myWhite),
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: MyColor().myOrange,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen(
      (barcode) => setState(
        () {
          this.barcode = barcode;
          globals.ipAddress = decrypt(barcode.code.toString());
          globals.isConnected = true;
          controller.dispose();
          Navigator.pop(context, "connected");
        },
      ),
    );
  }

  String decrypt(String cryptedQRCodeData) {
    // Parse the JSON string into a QRCodeData object
    QRCodeData data = QRCodeData.fromJson(json.decode(cryptedQRCodeData));

    var cypher = AesCrypt(key: data.key, padding: PaddingAES.pkcs7);
    String ip = cypher.cbc.decrypt(enc: data.encrypted, iv: data.iv);
    return ip;
  }
}
