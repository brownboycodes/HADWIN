import 'package:flutter/material.dart';

class LoginHelpScreen extends StatelessWidget {
  const LoginHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 64,
                ),
                Image.asset('assets/images/dr-monkey.jpg'),
                SizedBox(
                  height: 48,
                ),
                Text(
                  "This is a demo version, everything you need is mentioned in the project's documentation, you need to choose an account from the user accounts provided in the docs and use that for logging in, yet if you are unable to understand how to login, Dr Monkey suggests you to get checked by a real doctor A.S.A.P.",
                  style: TextStyle(fontSize: 16, color: Color(0xFF2b2d42)),
                ),
                SizedBox(
                  height: 36,
                ),
                Container(
                  child: Center(
                    child: InkWell(
                      child: Text(
                        'Go back to Login',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  width: double.infinity,
                  height: 36,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            padding: EdgeInsets.all(45),
            reverse: true,
          ),
          backgroundColor: Color(0xFFffffff),
        ),
        onWillPop: () => Future.value(false));
  }
}
