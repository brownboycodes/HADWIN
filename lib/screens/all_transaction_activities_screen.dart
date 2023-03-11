import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:hadwin/components/fund_transfer_screen/transaction_receipt_screen.dart';

import 'package:provider/provider.dart';
import 'package:hadwin/hadwin_components.dart';

class AllTransactionActivities extends StatefulWidget {
  final Map<String, dynamic> user;
  final String userAuthKey;
  final Function setTab;
  const AllTransactionActivities(
      {Key? key,
      required this.user,
      required this.userAuthKey,
      required this.setTab})
      : super(key: key);

  @override
  AllTransactionActivitiesState createState() =>
      AllTransactionActivitiesState();
}

class AllTransactionActivitiesState extends State<AllTransactionActivities> {
  List<dynamic> allTransactions = [];
  List<bool> _activeToggleMenu = [true, false, false];
  Map<String, dynamic>? error = null;
  late TextEditingController activitySearch;
  
  Widget appBarTitle =
      Text("Activities", style: TextStyle(color: Color(0xff243656)));
  Icon actionIcon = Icon(
    FluentIcons.search_24_regular,
    color: Color(0xff243656),
  );
  @override
  void initState() {
    super.initState();

    getTransactionsFromApi();
    
    activitySearch = TextEditingController();
    
  }

  void _updateTransactions() {
    if (mounted) {
      setState(() {
       
        allTransactions.sort(
            (a, b) => b['transactionDate'].compareTo(a['transactionDate']));
        for (var transaction in allTransactions) {
          String dateResponse =
              customGroup(DateTime.parse(transaction['transactionDate']));
          transaction['dateGroup'] = dateResponse;
        }
      });
    }
  }

  void getTransactionsFromApi() async {
    final response = await Future.wait([
      getData(
          urlPath: "/hadwin/v1/all-transactions", authKey: widget.userAuthKey),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
     backgroundColor: Color(0xfffdfdfd),
    //  backgroundColor: Color(0xfffcfcfc),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                int lastTab =
                    Provider.of<TabNavigationProvider>(context, listen: false)
                        .lastTab;
                Provider.of<TabNavigationProvider>(context, listen: false)
                    .removeLastTab();
                widget.setTab(lastTab);
              },
              icon: Icon(Icons.arrow_back, color: Color(0xff243656))),
          title: appBarTitle,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (actionIcon.icon == FluentIcons.search_24_regular) {
                    setState(() {
                      appBarTitle = Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Color(0xffF5F7FA),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.18))),
                        child: TextField(
                          controller: activitySearch,
                      
                          autofocus: true,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: TextStyle(color: Color(0xff929BAB)),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(6.18),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffF5F7FA), width: 1.618),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffF5F7FA), width: 1.618),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                color: Color(0xff929BAB),
                              )),
                        ),
                      );

                      actionIcon = Icon(
                        Icons.close,
                        color: Color(0xff243656),
                      );
                    });
                  
                  } else {
               
                    activitySearch.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      appBarTitle = Text("Activities",
                          style: TextStyle(color: Color(0xff243656)));
                      actionIcon = Icon(
                        FluentIcons.search_24_regular,
                        color: Color(0xff243656),
                      );
                    });
                  }
                },
                icon: actionIcon),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Column(children: <Widget>[
          SizedBox(
            height: 96,
          ),
          Container(
          
            decoration: BoxDecoration(
                color: Color(0xffF5F7FA),
                borderRadius: BorderRadius.circular(10)),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff929BAB),
              fillColor: Color(0xFF0070BA),
              selectedColor: Colors.white,
             
              renderBorder: false,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "All",
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Sent",
                      style: TextStyle(fontSize: 16),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Received",
                      style: TextStyle(fontSize: 16),
                    )),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < _activeToggleMenu.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      _activeToggleMenu[buttonIndex] = true;
                    } else {
                      _activeToggleMenu[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: _activeToggleMenu,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
              child: Container(
            height: 300,
            width: double.infinity,
            child: Builder(builder: (context) {
              if (error != null) {
                WidgetsBinding.instance!.addPostFrameCallback(
                    (_) => showErrorAlert(context, error!));

                return activitiesLoadingList(10);
              } else if (allTransactions.isEmpty) {
                return activitiesLoadingList(10);
              } else if (error == null) {
                List<dynamic> currentTransactions;
                if (activitySearch.text.isEmpty) {
                  currentTransactions = List.from(allTransactions);
                } else {
                  List<dynamic> nameMatch = allTransactions
                      .where((transaction) =>
                          RegExp("${activitySearch.text.toLowerCase()}")
                              .hasMatch(transaction['transactionMemberName']
                                  .toLowerCase()))
                      .toList();
                  List<dynamic> dateMatch = allTransactions
                      .where((transaction) =>
                          RegExp("${activitySearch.text.toLowerCase()}")
                              .hasMatch(dateFormatter(
                                      transaction['dateGroup'],
                                      DateTime.parse(
                                          transaction['transactionDate']))
                                  .toLowerCase()))
                      .toList();
                  List<dynamic> amountMatch = allTransactions
                      .where((transaction) =>
                          RegExp("${activitySearch.text.toLowerCase()}")
                              .hasMatch(transaction['transactionAmount']
                                  .toString()
                                  .toLowerCase()))
                      .toList();
                  currentTransactions = [
                    ...nameMatch,
                    ...dateMatch,
                    ...amountMatch
                  ].toSet().toList();
                }
                if (_activeToggleMenu[1] == true) {
                  currentTransactions = currentTransactions
                      .where((transaction) =>
                          transaction['transactionType'] == 'debit')
                      .toList();
                }
                if (_activeToggleMenu[2] == true) {
                  currentTransactions = currentTransactions
                      .where((transaction) =>
                          transaction['transactionType'] == 'credit')
                      .toList();
                }

                if (currentTransactions.isEmpty) {
                  return Center(
                    child: Text('no matches found'),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: GroupedListView<dynamic, String>(
                      padding: EdgeInsets.all(0),
                      groupComparator: (a, b) => customGroupComparator(a, b),
                      useStickyGroupSeparators: true,
                      stickyHeaderBackgroundColor: Color.fromARGB(252, 252, 252, 252),
                      elements: currentTransactions,
                      groupBy: (transaction) => transaction['dateGroup'],
                      
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          groupByValue,
                          style: TextStyle(color: Colors.blueGrey.shade700),
                        ),
                      ),
                      separator: Divider(
                        height: 14,
                        color: Colors.transparent,
                      ),
                      itemComparator: (a, b) =>
                          DateTime.parse(b['transactionDate'])
                              .compareTo(DateTime.parse(a['transactionDate'])),
                      itemBuilder: (context, transaction) {
                        Widget transactionMemberImage = FutureBuilder<int>(
                          future: checkUrlValidity(
                              "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${transaction['transactionMemberAvatar']}"),
                          builder: (context, snapshot) {
                            if (transaction.containsKey(
                                    'transactionMemberBusinessWebsite') &&
                                transaction
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
                                        "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${transaction['transactionMemberAvatar']}",
                                        height: 72,
                                        width: 72,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else if (transaction
                                    .containsKey('transactionMemberEmail') &&
                                transaction
                                    .containsKey('transactionMemberAvatar') &&
                                snapshot.hasData) {
                              if (snapshot.data == 404) {
                                return ClipOval(
                                  child: AspectRatio(
                                    aspectRatio: 1.0 / 1.0,
                                    child: Image.network(
                                      "${ApiConstants.baseUrl}/dist/images/hadwin_images/hadwin_users/${transaction['transactionMemberGender'].toLowerCase()}/${transaction['transactionMemberAvatar']}",
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
                                      "${ApiConstants.baseUrl}/dist/images/hadwin_images/brands_and_businesses/${transaction['transactionMemberAvatar']}",
                                      height: 72,
                                      width: 72,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Text(
                                transaction['transactionMemberName'][0]
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xff243656)),
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
                            contentPadding: EdgeInsets.only(
                                left: 0, top: 0, bottom: 0, right: 6.18),
                            leading: CircleAvatar(
                                radius: 38,
                                backgroundColor: Color(0xffF5F7FA),
                                child: transactionMemberImage),
                            title: Text(
                              transaction['transactionMemberName'],
                              style: TextStyle(
                                  fontSize: 16.5, color: Color(0xff243656)),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                dateFormatter(
                                    transaction['dateGroup'],
                                    DateTime.parse(
                                        transaction['transactionDate'])),
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff929BAB)),
                              ),
                            ),
                            trailing: Text(
                              transaction['transactionType'] == "credit"
                                  ? "+ \$ ${transaction['transactionAmount'].toString()}"
                                  : "- \$ ${transaction['transactionAmount'].toString()}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      transaction['transactionType'] == "credit"
                                          ? Color(0xff37d39b)
                                          : Color(0xfff47090)),
                            ),
                            onTap: () => _viewTransactionReceipt(transaction),
                          ),
                        );
                      },
                    ),
                  );
                }
              } else {
                return activitiesLoadingList(10);
              }
            }),
          )),
        ]));
  }

  void _viewTransactionReceipt(Map<String, dynamic> transaction) {
    Map<String, dynamic> transactionReceipt = {};
    transactionReceipt.addAll(transaction);
    if (!transactionReceipt.containsKey('transactionInitiatorName')) {
      transactionReceipt.addAll({
        'transactionInitiatorName':
            widget.user['first_name'] + " " + widget.user['last_name'],
        'transactionInitiatorPhoneNumber': widget.user['phone_number'],
        'transactionInitiatorEmail': widget.user['email'],
        'transactionInitiatorBankName': widget.user['bankDetails'][0]
            ['bankName'],
        'transactionInitiatorUid': widget.user['uid'],
        'transactionInitiatorWalletAddress': widget.user['walletAddress']
      });
    }
    Navigator.push(
        context,
        SlideRightRoute(
            page: TransactionReceiptScreen(
          transactionReceipt: transactionReceipt,
          transactionStatus: "successful",
        )));
  }
}
