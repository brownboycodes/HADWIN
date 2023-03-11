/*
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hadwin/components/qr_code_scanner_screen/scan_error_screen.dart';
import 'package:hadwin/screens/fund_transfer_screen.dart';
import 'package:hadwin/utilities/slide_right_route.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
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
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff243656),
        elevation: 0,
        title:
              Text("Scan QR Code", style: TextStyle(color: Color(0xff243656))),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
   
    var scanArea = 230.0;
   
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Color(0xFF0070BA),
          
          overlayColor: Colors.white.withOpacity(0.8),
          
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 15,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
 
      controller.pauseCamera();
      try {
        final data = jsonDecode(scanData.code!);
        int validFields = {
          'avatar',
          'homepage',
          'name',
          'walletAddress',
          'emailAddress',
          'phoneNumber',
          'communicationAddress'
        }.intersection(data.keys.toSet()).length;
        if (validFields >= 4) {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: FundTransferScreen(
                otherParty: data,
                transactionType: 'debit',
              ))).then((value) => controller.resumeCamera());
        } else {
          Navigator.push(context, SlideRightRoute(page: ScanErrorScreen()))
              .then((value) => controller.resumeCamera());
        }
      } catch (e) {
       
        Navigator.push(context, SlideRightRoute(page: ScanErrorScreen()))
            .then((value) => controller.resumeCamera());
      }
    });
  }


  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
*/