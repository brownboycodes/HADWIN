import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadwin/components/settings_screen/all_licenses.dart';
import 'package:hadwin/components/settings_screen/app_creator_info.dart';
import 'package:hadwin/components/settings_screen/credits_screen.dart';
import 'package:hadwin/database/cards_storage.dart';
import 'package:hadwin/database/login_info_storage.dart';
import 'package:hadwin/database/successful_transactions_storage.dart';
import 'package:hadwin/database/user_data_storage.dart';
import 'package:hadwin/providers/live_transactions_provider.dart';
import 'package:hadwin/providers/user_login_state_provider.dart';
import 'package:hadwin/utilities/hadwin_markdown_viewer.dart';
import 'package:hadwin/screens/login_screen.dart';
import 'package:hadwin/utilities/slide_right_route.dart';
import 'package:provider/provider.dart';

class AppSettingsComponent extends StatelessWidget {
  const AppSettingsComponent({Key? key}) : super(key: key);

  Future<bool> _deleteLoggedInUserData() async {
    List<bool> deletionStatus = await Future.wait(
        [LoginInfoStorage().deleteFile(), UserDataStorage().deleteFile()]);
    return deletionStatus.first && deletionStatus.last;
  }

  Future<bool> _resetTransactionsAndCards(BuildContext context) async {
    List<bool> deletionStatus = await Future.wait([
      CardsStorage().resetLocallySavedCards(),
      SuccessfulTransactionsStorage().resetLocallySavedTransactions(),
      Provider.of<UserLoginStateProvider>(context, listen: false)
          .resetBankBalance(),
      Provider.of<LiveTransactionsProvider>(context, listen: false)
          .resetTransactionsInState()
    ]);
    Set<bool> deletionStatusSet = deletionStatus.toSet();
    return deletionStatusSet.length == 1 && deletionStatusSet.first == true;
  }

  @override
  Widget build(BuildContext context) {
    final data = _settingsMenu(context);

    return ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListTile(
              textColor: Color(0xff243656),
              contentPadding: EdgeInsets.all(5),
              title: data[index]['title'],
              trailing: data[index]['trailing'],
              onTap: data[index]['onTap'],
            ),
          );
        },
        separatorBuilder: (_, b) => Divider(
              height: 6,
              color: Colors.grey.shade300,
            ),
        itemCount: data.length);
  }

  List<dynamic> _settingsMenu(BuildContext context) {
    List<dynamic> settingsMenuItems = [
      {
        'title': Text('Credits'),
        'trailing': Icon(FluentIcons.star_emphasis_24_regular),
        'onTap': () {
          Navigator.push(context, SlideRightRoute(page: CreditsScreen()));
        },
        'settingsCategory': 'About the app',
      },
      {
        'title': Text('Privacy Policy'),
        'trailing': Icon(FluentIcons.info_24_regular),
        'onTap': () =>
            openDocsViewer('PRIVACY_POLICY', 'Privacy Policy', context),
        'settingsCategory': 'About the app',
      },
      {
        'title': Text('Terms of use'),
        'trailing': Icon(FluentIcons.info_24_regular),
        'onTap': () => openDocsViewer(
            'TERMS_AND_CONDITIONS', 'Terms & Conditions', context),
        'settingsCategory': 'About the app',
      },
      {
        'title': Text('End User License Agreement'),
        'trailing': Icon(FluentIcons.info_24_regular),
        'onTap': () => openDocsViewer(
            'END_USER_LICENSE_AGREEMENT', 'End User License Agreement', context),
        'settingsCategory': 'About the app',
      },
      {
        'title': Text('Share feedback'),
        'trailing': Icon(FluentIcons.person_feedback_24_regular),
        'onTap': () {
          Navigator.push(
              context, SlideRightRoute(page: AppCreatorInfoScreen()));
        },
        'settingsCategory': 'About the app',
      },
      {
        'title': Text('Licenses'),
        'trailing': Icon(FluentIcons.book_24_regular),
        'onTap': () {
          Navigator.push(context, SlideRightRoute(page: AllLicenses()));
        },
        'settingsCategory': 'About the app',
      },
      {
        'title': Text('Reset'),
        'trailing': Icon(FluentIcons.warning_24_regular),
        'onTap': () => showDialogOnResetDataRequest(context),
        'settingsCategory': 'General',
      },
      {
        'title': Text('Sign Out'),
        'trailing': Icon(FluentIcons.sign_out_24_regular),
        'onTap': () async {
          bool logOutStatus = await _deleteLoggedInUserData();
          if (logOutStatus) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          }
        },
        'settingsCategory': 'General',
      },
      {
        'title': Padding(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 0),
            child: Image.asset(
              'assets/images/hadwin_system/hadwin-logo-with-name.png',
            )),
        'trailing': null,
        'onTap': null,
        'settingsCategory': 'About the app',
      },
    ];

    return settingsMenuItems;
  }

  void showDialogOnResetDataRequest(BuildContext context) {
    Decoration buttonDecoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: Colors.blueGrey.shade100,
            offset: Offset(0, 4),
            blurRadius: 5.0)
      ],
      gradient: RadialGradient(
          colors: [Color(0xff0070BA), Color(0xff1546A0)],
          radius: 8.4,
          center: Alignment(-0.24, -0.36)),
      borderRadius: BorderRadius.circular(10),
    );
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(
                "Reset",
                textAlign: TextAlign.center,
              ),
              content: Text(
                "This will delete all locally saved transactions and cards.\nDo you wish to continue?",
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 48,
                          width: 100,
                          decoration: buttonDecoration,
                          child: ElevatedButton(
                              onPressed: () async {
                                bool deleted =
                                    await _resetTransactionsAndCards(context);
                                if (deleted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('Reset'),
                              style: buttonStyle),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Container(
                          height: 48,
                          width: 100,
                          decoration: buttonDecoration,
                          child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                              style: buttonStyle),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                )
              ],
            ));
  }

  void openDocsViewer(String docName, String screenName, BuildContext context) {
    Navigator.push(
        context,
        SlideRightRoute(
            page: HadWinMarkdownViewer(
          screenName: screenName,
          urlRequested:
              'https://raw.githubusercontent.com/brownboycodes/HADWIN/master/docs/$docName.md',
        )));
  }
}
