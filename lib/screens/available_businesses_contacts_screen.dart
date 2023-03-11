import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadwin/hadwin_components.dart';

import 'package:provider/provider.dart';

class AvailableBusinessesAndContactsScreen extends StatefulWidget {
  final String transactionType;
  const AvailableBusinessesAndContactsScreen(
      {Key? key, required this.transactionType})
      : super(key: key);

  @override
  _AvailableBusinessesAndContactsScreenState createState() =>
      _AvailableBusinessesAndContactsScreenState();
}

class _AvailableBusinessesAndContactsScreenState
    extends State<AvailableBusinessesAndContactsScreen> {
  late String transactionButton;
  late TextEditingController contactSearchController;

List<String> searchHintsList = [
      'Search...',
      'Search for a contact by their name',
      'Search for a business',
      'Search by their phone number',
      'Search by their email id',
      'Search by their website'
    ];
    int currentSearchHintIndex = 0;
    Timer? _updateContactsSearchingHintTimer;
  @override
  void initState() {
    super.initState();
    transactionButton = widget.transactionType == 'debit' ? "Pay" : 'Request';
    contactSearchController = TextEditingController();
    _updateContactsSearchingHintTimer =
        Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted && contactSearchController.text.isEmpty) {
        setState(() {
        if (currentSearchHintIndex == searchHintsList.length - 1) {
        currentSearchHintIndex = 0;
      } else {
        currentSearchHintIndex++;
      }
      });
     //* search hint updated
      }
    });
  }

  @override
  void dispose() {
    _updateContactsSearchingHintTimer!.cancel();
    contactSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userAuthKey =
        Provider.of<UserLoginStateProvider>(context).userLoginAuthKey;
    

    String currentSearchHint = searchHintsList[currentSearchHintIndex];
    return Scaffold(
    
    backgroundColor: Color(0xfffdfdfd),
      // backgroundColor: Color(0xfffcfcfc),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Future.delayed(Duration(milliseconds: 200),
                  (() => Navigator.of(context).pop()));
            },
            icon: Icon(Icons.arrow_back, color: Color(0xff243656))),
        title: Text(
          "Businesses and Contacts",
          style: TextStyle(fontSize: 17.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xff243656),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     SlideRightRoute(
                //         page: widget.transactionType == 'debit'
                //             ? QRCodeScannerScreen()
                //             : MyQRCodeScreen()));
              },
              icon: Icon(FluentIcons.qr_code_28_regular,
                  color: Color(0xff243656))),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 28),
            child: TextField(
              controller: contactSearchController,
              onChanged: (value) {
                setState(() {});
              },
              style: TextStyle(color: Color(0xff929BAB)),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffF5F7FA), width: 1.618),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffF5F7FA), width: 1.618),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  hintText: currentSearchHint,
                  hintStyle: TextStyle(color: Color(0xff929BAB))),
            ),
          ),
          Expanded(
            child: Container(
              height: 300,
              width: double.infinity,
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  getData(
                      urlPath: "/hadwin/v2/businesses-and-brands",
                      authKey: userAuthKey),
                  getData(
                      urlPath: "/hadwin/v3/all-contacts", authKey: userAuthKey)
                ]),
                builder: (context, snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    if (snapshot.data![0].keys
                            .join()
                            .toLowerCase()
                            .contains("error") ||
                        snapshot.data![1].keys
                            .join()
                            .toLowerCase()
                            .contains("error")) {
                      Map<String, dynamic> error = snapshot.data![0].keys
                              .join()
                              .toLowerCase()
                              .contains("error")
                          ? snapshot.data![0]
                          : snapshot.data![1];
                      WidgetsBinding.instance!.addPostFrameCallback(
                          (_) => showErrorAlert(context, error));

                     

                      return contactsLoadingList(10);
                    } else {
                      List<dynamic> data;
                   
                      if (contactSearchController.text.isEmpty) {
                        data = [
                          ...snapshot.data![0]['businesses'],
                          ...snapshot.data![1]['contacts']
                        ];
                      } else {
                        data = [
                          ...snapshot.data![0]['businesses'],
                          ...snapshot.data![1]['contacts']
                        ];
                   
                        List<dynamic> nameMatch = data
                            .where((contact) =>
                                RegExp("${contactSearchController.text.toLowerCase()}")
                                    .hasMatch(contact['name'].toLowerCase()))
                            .toList();
                        List<dynamic> emailMatch = data
                            .where((contact) =>
                                contact.containsKey('emailAddress') &&
                                RegExp("${contactSearchController.text.toLowerCase()}")
                                    .hasMatch(
                                        contact['emailAddress'].toLowerCase()))
                            .toList();
                        List<dynamic> phoneNumberMatch = data
                            .where((contact) =>
                                contact.containsKey('phoneNumber') &&
                                RegExp("${contactSearchController.text.toLowerCase()}")
                                    .hasMatch(
                                        contact['phoneNumber'].toLowerCase()))
                            .toList();
                        List<dynamic> webSiteMatch = data
                            .where((contact) =>
                                contact.containsKey('homepage') &&
                                RegExp("${contactSearchController.text.toLowerCase()}")
                                    .hasMatch(
                                        contact['homepage'].toLowerCase()))
                            .toList();
                        data = [
                          ...nameMatch,
                          ...emailMatch,
                          ...phoneNumberMatch,
                          ...webSiteMatch
                        ].toSet().toList();
                      }
                      data.sort((a, b) => a['name']
                          .toLowerCase()
                          .compareTo(b['name'].toLowerCase()));
                      if (data.isEmpty) {
                        return Center(
                          child: Text('no matches found'),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28),
                          child: ListView.separated(
                              padding: EdgeInsets.all(0),
                              itemBuilder: (_, index) {
                                Widget contactImage;
                                if (data[index].containsKey('homepage') &&
                                    data[index].containsKey('avatar')) {
                                  contactImage = ClipOval(
                                    child: AspectRatio(
                                      aspectRatio: 1.0 / 1.0,
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                        
                                          Color(0xff243656),
                                          BlendMode.color,
                                        ),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.saturation,
                                          ),
                                          child: Image.network(
                                            "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${data[index]['avatar']}",
                                            height: 72,
                                            width: 72,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (data[index]
                                        .containsKey('emailAddress') &&
                                    data[index].containsKey('avatar')) {
                                  contactImage = ClipOval(
                                    child: AspectRatio(
                                      aspectRatio: 1.0 / 1.0,
                                      child: Image.network(
                                        "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${data[index]['avatar']}",
                                        height: 72,
                                        width: 72,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                } else {
                                  contactImage = Text(
                                    data[index]['name'][0].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xff243656)),
                                  );
                                }

                                String tileSubtitle;

                                if (data[index].containsKey('emailAddress') &&
                                    data[index].containsKey('avatar')) {
                                  tileSubtitle = data[index]['emailAddress'];
                                } else if (data[index]
                                        .containsKey('homepage') &&
                                    data[index].containsKey('avatar')) {
                                  tileSubtitle = data[index]['homepage'];
                                } else {
                                  tileSubtitle = data[index]['phoneNumber'];
                                }

                                return Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        /*
                                          color: Color(0xffF5F7FA),
                                          blurRadius: 4,
                                          offset: Offset(0.0, 3),
                                          spreadRadius: 0
                                          */
                                          color: Color(0xff1546a0).withOpacity(0.1),
                                  blurRadius: 48,
                                  offset: Offset(2, 8),
                                  spreadRadius: -16
                                          ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    horizontalTitleGap: 18,
                                    leading: CircleAvatar(
                                        radius: 38,
                                        backgroundColor: Color(0xffF5F7FA),
                                        child: contactImage),
                                    title: Text(
                                      data[index]['name'],
                                      style: TextStyle(
                                          fontSize: 16.5,
                                          color: Color(0xff243656)),
                                    ),
                                    subtitle: Container(
                                        margin: EdgeInsets.only(top: 7.2),
                                        child: Text(tileSubtitle,style: TextStyle(fontSize: 13,color: Color(0xff929BAB)),)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: FundTransferScreen(
                                            otherParty: data[index],
                                            transactionType:
                                                widget.transactionType,
                                          )));
                                    },
                                  ),
                                );
                              },
                              separatorBuilder: (_, b) => Divider(
                                    height: 14,
                                    color: Colors.transparent,
                                  ),
                              itemCount: data.length),
                        );
                      }
                    }
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    return contactsLoadingList(10);
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
