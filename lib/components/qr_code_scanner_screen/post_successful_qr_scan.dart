/*
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class PostSuccessfulQRScanScreen extends StatelessWidget {
  final Barcode result;
  const PostSuccessfulQRScanScreen({Key? key, required this.result})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    dynamic tests = 'untouched';
    try {
      
      tests = json.decode(result.code!);
    } catch (e) {
      tests = e.toString();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xff243656),
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Text("QR Scan Result",
              style: TextStyle(color: Color(0xff243656))),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            child: Text('Data: ${tests}'),
          ))
        ],
      ),
    );
  }
}
*/