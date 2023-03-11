import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadwin/hadwin_components.dart';

import 'package:provider/provider.dart';

class HomeDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final String? userAuthKey;
  final Function setTab;
  const HomeDashboardScreen(
      {Key? key,
      required this.user,
      required this.userAuthKey,
      required this.setTab})
      : super(key: key);

  @override
  HomeDashboardScreenState createState() => HomeDashboardScreenState();
}

class HomeDashboardScreenState extends State<HomeDashboardScreen> {
  List<dynamic> allTransactions = [];
  late List<Map<String, dynamic>> response;
  Map<String, dynamic>? error = null;

  @override
  void initState() {
    super.initState();
    getTransactionsFromApi();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dashboardActions = [
      GestureDetector(
        onTap: goToWalletScreen,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 26,
            child: ClipOval(
              child: Image.network(
                "${ApiConstants.baseUrl}/dist/images/hadwin_images/hadwin_users/${widget.user['gender'].toLowerCase()}/${widget.user['avatar']}",
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      )
    ];
    List<Widget> dashboardContents = [
      Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            // color: Color(0xFF0070BA),
            color: Color(0xff1546A0),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(36),
            ),
          )),
      Positioned(
          child: Opacity(
            opacity: 0.16,
            child: Image.asset(
              "assets/images/hadwin_system/magicpattern-blob-1652765120695.png",
              color: Colors.white,
              height: 480,
            ),
          ),
        
          left: -156,
          top: -96),
      Positioned(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/hadwin_system/hadwin-logo-lite.png',
                height: 48,
                width: 48,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Hello, ${widget.user['first_name']}!",
                style: TextStyle(color: Colors.grey.shade300, fontSize: 17),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "\$ ${context.watch<UserLoginStateProvider>().bankBalance}",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.96),
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6.18,
              ),
              Text(
                "Your balance",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
        ),
        bottom: 20,
        left: 10,
      )
    ];
    List<Widget> transactionButtons = <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () => _makeATransaction('debit'),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.file_upload_outlined,
                    size: 24,
                  ),
                ),
                Spacer(),
                Text(
                  "Send Money",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
              // primary: Color(0xFF0070BA),
              primary: Color(0xff1546A0),
              // fixedSize: Size(90, 100),
              fixedSize: Size(96, 108),
              shadowColor: Color(0xFF0070BA).withOpacity(0.618),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            )),
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
            onPressed: () => _makeATransaction('credit'),
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.file_download_outlined,
                    size: 24,
                    color: Color(0xFF0070BA),
                  )),
              Spacer(),
              Text(
                "Request Payment",
                style: TextStyle(color: Color(0xFF0070BA), fontSize: 13),
              ),
              SizedBox(
                height: 10,
              )
            ]),
            style: ElevatedButton.styleFrom(
              // fixedSize: Size(90, 100),
              fixedSize: Size(96, 108),
              primary: Colors.white,
              shadowColor: Color(0xffF5F7FA).withOpacity(0.618),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            )),
      ),
      PopupMenuButton<_ScanOptions>(
        icon: Icon(
          FluentIcons.more_vertical_28_regular,
          color: Colors.grey,
        ),
        offset: Offset(119, -27),
        onSelected: (value) {
          if (value == _ScanOptions.ScanQRCode) {
            // Navigator.push(
            //         context, SlideRightRoute(page: QRCodeScannerScreen()))
            //     .whenComplete(() => setState(() {}));
          } else {
            // Navigator.push(context, SlideRightRoute(page: MyQRCodeScreen()))
            //     .whenComplete(() => setState(() {}));
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Scan QR Code"),
            value: _ScanOptions.ScanQRCode,
          ),
          PopupMenuItem(
            child: Text("My QR Code"),
            value: _ScanOptions.MyQRCode,
          )
        ],
      )
    ];

    List<Widget> homeScreenContents = <Widget>[
      Stack(
        children: dashboardContents,
      ),
      Container(
        padding: EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: transactionButtons,
          ),
        ),
      ),
      Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 150,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          "Activity",
                          style:
                              TextStyle(fontSize: 21, color: Color(0xff243656)),
                        ),
                        Spacer(),
                        InkWell(
                          child: Text("View all",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          onTap: _viewAllActivities,
                        )
                      ],
                    ),
                    width: double.infinity,
                  ),
                  Expanded(
                    child: Container(
                      height: 145,
                      child: Builder(builder: _buildTransactionActivities),
                    ),
                  )
                ],
              )))
    ];

    return Scaffold(
        // backgroundColor: Color.fromARGB(255, 253, 253, 253),
 backgroundColor: Color(0xfffcfcfc),
        appBar: AppBar(
          actions: dashboardActions,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: homeScreenContents,
              ))
        ]));
  }

  void _makeATransaction(String transactionType) {
    Navigator.push(
            context,
            SlideRightRoute(
                page: AvailableBusinessesAndContactsScreen(
                    transactionType: transactionType)))
        .then((value) => getTransactionsFromApi());
  }

  Widget _buildTransactionActivities(BuildContext context) {
    if (error != null) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => showErrorAlert(context, error!));

      return activitiesLoadingList(10);
    } else if (allTransactions.isEmpty) {
      return activitiesLoadingList(4);
    } else if (error == null) {
      List<dynamic> currentTransactions =
          List.from(allTransactions).sublist(0, 4);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.separated(
          padding: EdgeInsets.all(0),
          separatorBuilder: (_, b) => Divider(
            height: 14,
            color: Colors.transparent,
          ),
          itemCount: currentTransactions.length,
          itemBuilder: (BuildContext context, int index) {
            Widget transactionMemberImage = FutureBuilder<int>(
              future: checkUrlValidity(
                  "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${currentTransactions[index]['transactionMemberAvatar']}"),
              builder: (context, snapshot) {
                if (currentTransactions[index]
                        .containsKey('transactionMemberBusinessWebsite') &&
                    currentTransactions[index]
                        .containsKey('transactionMemberAvatar')) {
                  return ClipOval(
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
                            "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${currentTransactions[index]['transactionMemberAvatar']}",
                            height: 72,
                            width: 72,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (currentTransactions[index]
                        .containsKey('transactionMemberEmail') &&
                    currentTransactions[index]
                        .containsKey('transactionMemberAvatar') &&
                    snapshot.hasData) {
                  if (snapshot.data == 404) {
                    return ClipOval(
                      child: AspectRatio(
                        aspectRatio: 1.0 / 1.0,
                        child: Image.network(
                          "${ApiConstants.baseUrl}/dist/images/hadwin_images/hadwin_users/${currentTransactions[index]['transactionMemberGender'].toLowerCase()}/${currentTransactions[index]['transactionMemberAvatar']}",
                          height: 72,
                          width: 72,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  } else {
                    return ClipOval(
                      child: AspectRatio(
                        aspectRatio: 1.0 / 1.0,
                        child: Image.network(
                          "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${currentTransactions[index]['transactionMemberAvatar']}",
                          height: 72,
                          width: 72,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
                } else {
                  return Text(
                    currentTransactions[index]['transactionMemberName'][0]
                        .toUpperCase(),
                    style: TextStyle(fontSize: 20, color: Color(0xff243656)),
                  );
                }
              },
            );

            return Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
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
                contentPadding:
                    EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 6.18),
                leading: CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xffF5F7FA),
                    child: transactionMemberImage),
                title: Text(
                  currentTransactions[index]['transactionMemberName'],
                  style: TextStyle(fontSize: 16.5, color: Color(0xff243656)),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    dateFormatter(
                        currentTransactions[index]['dateGroup'],
                        DateTime.parse(
                            currentTransactions[index]['transactionDate'])),
                    style: TextStyle(fontSize: 12, color: Color(0xff929BAB)),
                  ),
                ),
                trailing: Text(
                  currentTransactions[index]['transactionType'] == "credit"
                      ? "+ \$ ${currentTransactions[index]['transactionAmount'].toString()}"
                      : "- \$ ${currentTransactions[index]['transactionAmount'].toString()}",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: currentTransactions[index]['transactionType'] ==
                              "credit"
                          ? Color(0xff37d39b)
                          : Color(0xfff47090)),
                ),
                onTap: _viewAllActivities,
              ),
            );
          },
        ),
      );
    } else {
      return activitiesLoadingList(4);
    }
  }

  void goToWalletScreen() {
    widget.setTab(3);
    Provider.of<TabNavigationProvider>(context, listen: false).updateTabs(0);
  }

  void _viewAllActivities() {
    Provider.of<TabNavigationProvider>(context, listen: false).updateTabs(0);
    widget.setTab(2);
  }

  void _updateTransactions() {
    setState(() {
      allTransactions
          .sort((a, b) => b['transactionDate'].compareTo(a['transactionDate']));
      for (var transaction in allTransactions) {
        String dateResponse =
            customGroup(DateTime.parse(transaction['transactionDate']));
        transaction['dateGroup'] = dateResponse;
      }
    });
  }

  void getTransactionsFromApi() async {
    response = await Future.wait([
      getData(
          urlPath: "/hadwin/v1/all-transactions", authKey: widget.userAuthKey!),
      SuccessfulTransactionsStorage().getSuccessfulTransactions()
    ]);

    if (response[0].keys.join().toLowerCase().contains("error") ||
        response[1].keys.join().toLowerCase().contains("error")) {
      setState(() {
        error = response[0].keys.join().toLowerCase().contains("error")
            ? response[0]
            : response[1];
      });
    } else {
      if (mounted) {
        setState(() {
          allTransactions = [
            ...response[0]['transactions'],
            ...response[1]['transactions']
          ];
        });
        _updateTransactions();
      }
    }
  }
}

enum _ScanOptions { ScanQRCode, MyQRCode }
