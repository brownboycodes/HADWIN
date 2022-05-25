import 'dart:async';
import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:hadwin/providers/live_transactions_provider.dart';
import 'package:hadwin/providers/tab_navigation_provider.dart';

import 'package:hadwin/providers/user_login_state_provider.dart';

import 'package:hadwin/screens/all_contacts.dart';
import 'package:hadwin/screens/all_transaction_activities_screen.dart';

import 'package:hadwin/screens/home_dashboard_screen.dart';

import 'package:hadwin/screens/wallet_screen.dart';
import 'package:hadwin/utilities/hadwin_icons.dart';

import 'package:provider/provider.dart';

class TabbedLayoutComponent extends StatefulWidget {
  final Map<String, dynamic> userData;
  const TabbedLayoutComponent({Key? key, required this.userData})
      : super(key: key);
  @override
  _TabbedLayoutComponentState createState() =>
      new _TabbedLayoutComponentState();
}

class _TabbedLayoutComponentState extends State<TabbedLayoutComponent> {

  Timer? _updateTransactionsTimer;
  int _currentTab = 0;
  int totalTransactionRequests = 0;

  final LabeledGlobalKey<HomeDashboardScreenState> dashboardScreenKey =
      LabeledGlobalKey("Dashboard Screen");
  final LabeledGlobalKey<AllTransactionActivitiesState>
      transactionActivitiesScreenKey =
      LabeledGlobalKey("Transaction Activities Screen");

  @override
  void initState() {
    super.initState();

    _updateTransactionsTimer = Timer.periodic(
        Duration(minutes: [1, 2, 3, 4][Random().nextInt(4)]), (Timer t) {
      Provider.of<LiveTransactionsProvider>(context, listen: false)
          .updateTransactionRequests();
     
    });
  
  }

  @override
  void dispose() {
    _updateTransactionsTimer!.cancel();
    super.dispose();
  }

  void setTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String userAuthKey =
        Provider.of<UserLoginStateProvider>(context).userLoginAuthKey;

    List<Widget> screens = [
      HomeDashboardScreen(
        user: widget.userData,
        userAuthKey: userAuthKey,
        setTab: setTab,
        key: dashboardScreenKey,
      ),
      AllContactsScreen(
        userAuthKey: userAuthKey,
        setTab: setTab,
      ),
      AllTransactionActivities(
        user: widget.userData,
        userAuthKey: userAuthKey,
        setTab: setTab,
        key: transactionActivitiesScreenKey,
      ),
      WalletScreen(
        setTab: setTab,
        user: widget.userData,
      ),
    ];
    ;
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
     
        // backgroundColor: Colors.white,
         backgroundColor: Color(0xfffefefe),

        extendBodyBehindAppBar: true,

        bottomNavigationBar: googleNavBar(),

        body: screens.isEmpty ? Text("Loading...") : screens[_currentTab],
      ),
    );
  }

  Widget googleNavBar() {
    int unreadTransactions =
        context.watch<LiveTransactionsProvider>().unreadTransactions;
    int transactionRequests =
        context.watch<LiveTransactionsProvider>().transactionRequests;
    if (transactionRequests != totalTransactionRequests) {
      setState(() {
        totalTransactionRequests = transactionRequests;
      });
      if (_currentTab == 0) {
        dashboardScreenKey.currentState!.getTransactionsFromApi();
      } else if (_currentTab == 2) {
        transactionActivitiesScreenKey.currentState!.getTransactionsFromApi();
      }
    }

    return Container(
    
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.18, vertical: 1),
        child: GNav(
          haptic: false,
          gap: 6,
          activeColor: Color(0xFF0070BA),
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          duration: Duration(milliseconds: 300),
          color: Color(0xFF243656),
          tabs: [
            GButton(
              icon: FluentIcons.home_32_regular,
              iconSize: 36,
              text: 'Home',
            ),
            GButton(
              icon: FluentIcons.people_32_regular,
              iconSize: 36,
              text: 'Contacts',
            ),
            GButton(
              icon: FluentIcons.alert_32_regular,
              iconActiveColor: Color(0xFF0070BA),
              text: 'Activities',
              leading: Stack(
                children: [
                  Icon(
                    FluentIcons.alert_32_regular,
                    color: _currentTab == 2
                        ? Color(0xFF0070BA)
                        : Color(0xFF243656),
                    size: 36,
                  ),
                  if (unreadTransactions > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ClipOval(
                        child: Container(
                          
                            color: Color(0xffffb3c1),
                            width: 17,
                            height: 17,
                         
                            child: Center(
                              child: Text(unreadTransactions.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 9.6,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffc9184a),
                               
                                      backgroundColor: Color(0xffffb3c1))),
                            )),
                      ),
                    )
                ],
              ),
            ),
            GButton(
              icon: HadWinIcons.line_awesome_wallet_solid,
            
              text: 'Wallet',
            
              iconSize: 34,
            ),
          ],
          selectedIndex: _currentTab,
          onTabChange: _onTabChange,
        ),
      ),
     
    );
  }

  void _onTabChange(index) {
    if (_currentTab == 1 || _currentTab == 2) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    Provider.of<TabNavigationProvider>(context, listen: false)
        .updateTabs(_currentTab);
    setState(() {
      _currentTab = index;
    });
  }

  Future<bool> _onBackPress() {
    if (_currentTab == 0) {
      return Future.value(true);
    } else {
      int lastTab =
          Provider.of<TabNavigationProvider>(context, listen: false).lastTab;
      Provider.of<TabNavigationProvider>(context, listen: false)
          .removeLastTab();
      setTab(lastTab);
    }
    return Future.value(false);
  }
}
