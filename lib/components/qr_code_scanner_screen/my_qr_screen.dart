/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadwin/database/user_data_storage.dart';

import 'package:qr_flutter/qr_flutter.dart';

class MyQRCodeScreen extends StatelessWidget {
  const MyQRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffedf2f4),
      appBar: AppBar(
        title: Text("My QR Code"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xff243656),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
     
          children: [
            SizedBox(
              height: 36,
            ),
            Text(
              "Share this code",
              style: GoogleFonts.poppins(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              "( HADWIN is a prototype \nyou cannot send\nor receive real money )",
              style: GoogleFonts.poppins(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 64,
            ),
            Stack(children: [
              ClipPath(
                clipper: QRClipper(),
                child: Container(
                  width: 304,
                  height: 304,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.red,
                      width: 8.4,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              Container(
                  width: 304,
                  height: 304,
                  padding: EdgeInsets.all(24),
                  child: FutureBuilder<Map<String, dynamic>>(
                      future: UserDataStorage().getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> userData = snapshot.data!;
                          Map<String, dynamic> qrFields = {
                            'avatar': userData['avatar'],
                            'name': userData['first_name'] +
                                " " +
                                userData['last_name'],
                            'gender': userData['gender'],
                            'walletAddress': userData['walletAddress'],
                            'emailAddress': userData['email'],
                            'phoneNumber': userData['phone_number'],
                            'communicationAddress':
                                "${userData['address']['street_name']}, ${userData['address']['street_address']}, ${userData['address']['city']}, ${userData['address']['state']} ${userData['address']['zip_code']}, ${userData['address']['country']}"
                          };
                          return QrImage(
                            data: json.encode(qrFields),
                            version: QrVersions.auto,

                            size: 240,
                            gapless: false,
                            errorStateBuilder: (cxt, err) {
                              return Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Uh oh! Something went wrong...",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              color: Colors.cyan.shade400,
                              strokeWidth: 6.18,
                            ),
                          ));
                        }
                      }))
            ])
          
          ],
        ),
      )),
    );
  }
}

class QRClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path
      ..moveTo(size.width * .8, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * .2)
      ..moveTo(size.width, size.height * .8)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * .8, size.height)
      ..moveTo(size.width * .2, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height * .8)
      ..moveTo(0, size.height * .2)
      ..lineTo(0, 0)
      ..lineTo(size.width * .2, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;

  }
}
*/