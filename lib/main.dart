import 'package:flutter/material.dart';
import 'package:paypal_concept/screens/login_screen.dart';
// import 'package:paypal_concept/screens/test_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PayPal Concept',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        /*
        home: Scaffold(
          body: Center(
            child: RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Work in Progress",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  TextSpan(
                    text: " 🚧 ",
                    style: TextStyle(fontFamily: 'EmojiOne', fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
        */
        // home: HomeScreen(),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false);
  }
}
