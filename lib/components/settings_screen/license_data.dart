import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LicenseData extends StatelessWidget {
  const LicenseData(
      {Key? key, required this.licenseName, required this.licenseData})
      : super(key: key);
  final String licenseName;
  final List<Iterable<LicenseParagraph>> licenseData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            licenseName,
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xff243656),
          elevation: 0,
        ),
        body: Column(children: [
          
          Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height - 180,
                  padding: EdgeInsets.all(10),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      List<Widget> paraBody = [];
                      licenseData[index].forEach(
                        (element) {
                          paraBody.add(Container(
                              width: MediaQuery.of(context).size.width - 10,
                              margin: EdgeInsets.symmetric(vertical: 6.18),
                              child: Text(element.text)));
                        },
                      );
                      return Column(
                     
                          children: paraBody);
                    },
                    separatorBuilder: (_, b) => Divider(
                      height: 6,
                      color: Colors.transparent,
                    ),
                    itemCount: licenseData.length,
                  ))),
        ]));
  }
}
