import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:hadwin/components/main_app_screen/local_splash_screen_component.dart';

import 'package:hadwin/components/main_app_screen/tabbed_layout_component.dart';
import 'package:hadwin/database/cards_storage.dart';
import 'package:hadwin/database/login_info_storage.dart';
import 'package:hadwin/database/hadwin_user_device_info_storage.dart';
import 'package:hadwin/database/successful_transactions_storage.dart';
import 'package:hadwin/database/user_data_storage.dart';
import 'package:hadwin/providers/live_transactions_provider.dart';
import 'package:hadwin/providers/tab_navigation_provider.dart';

import 'package:hadwin/providers/user_login_state_provider.dart';
import 'package:hadwin/screens/login_screen.dart';
import 'package:hadwin/utilities/make_api_request.dart';
import 'package:hadwin/screens/onboarding_screen.dart';

import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserLoginStateProvider(),
      ),
      ChangeNotifierProxyProvider<UserLoginStateProvider,
              LiveTransactionsProvider>(
          create: (BuildContext context) => LiveTransactionsProvider(),
          update: (context, userLoginAuthKey, liveTransactions) =>
              liveTransactions!..update(userLoginAuthKey)),
      ChangeNotifierProvider(create: (_) => TabNavigationProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserDeviceInfoStorage userDeviceInfoStorage = UserDeviceInfoStorage();
  UserDataStorage userDataStorage = UserDataStorage();
  LoginInfoStorage loginInfoStorage = LoginInfoStorage();
  bool? _previousllyInstalled = null;
  bool? _isLoggedIn = null;
  Map<String, dynamic>? _loggedInUserData = null;

  void _checkForPreviousInstallations() async {
    final previousllyInstalledStatus =
        await userDeviceInfoStorage.wasUsedBefore;
    setState(() {
      _previousllyInstalled = previousllyInstalledStatus;
    });
  }

  void _getLoggedInUserData() async {
    final loginData = await loginInfoStorage.getPersistentLoginData;
    final loggedInUserAuthKey = loginData['authToken'];
    final loggedInUserId = loginData['userId'];
    bool loginStatus;
    if (loggedInUserAuthKey == null || loggedInUserId == null) {
      loginStatus = false;
    } else {
      Provider.of<UserLoginStateProvider>(context, listen: false)
          .setAuthKeyValue(loggedInUserAuthKey);

      await CardsStorage().initializeAvailableCards(loggedInUserAuthKey);
      await SuccessfulTransactionsStorage().initializeSuccessfulTransactions();

      final userValidity =
          await fetchUserId(loggedInUserAuthKey, loggedInUserId);
      //* user data saved

      loginStatus = userValidity;
    }
    setState(() {
      _isLoggedIn = loginStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _checkForPreviousInstallations();

    _getLoggedInUserData();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HADWIN',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme:
                GoogleFonts.manropeTextTheme(Theme.of(context).textTheme)),
        home: Builder(
          builder: (context) {
            if (_previousllyInstalled == false) {
              FlutterNativeSplash.remove();
              return OnboardingScreen();
            } else if (_isLoggedIn == true && _loggedInUserData != null) {
              FlutterNativeSplash.remove();
              return TabbedLayoutComponent(
                userData: _loggedInUserData!,
              );
            } else if (_isLoggedIn == false) {
              FlutterNativeSplash.remove();
              return LoginScreen();
            } else {
              return Material(
                type: MaterialType.transparency,
                child: LocalSplashScreenComponent(),
              );
            }
          },
        ),
        debugShowCheckedModeBanner: false);
  }

  Future<bool> fetchUserId(String authKey, String userId) async {
    final dataReceived =
        await getData(urlPath: "/hadwin/v3/user/$userId", authKey: authKey);
    if (dataReceived.keys.join().toLowerCase().contains("error")) {
      return false;
    } else {
      bool userIsSaved =
          await UserDataStorage().saveUserData(dataReceived['user']);
      Provider.of<UserLoginStateProvider>(context, listen: false)
          .initializeBankBalance(dataReceived['user']);

      if (userIsSaved) {
        //? in case user is valid
        if (mounted) {
          setState(() {
            _loggedInUserData = dataReceived['user'];
          });
        }
      }

      return userIsSaved;
    }
  }
}
