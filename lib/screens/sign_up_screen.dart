import 'package:flutter/material.dart';

import 'package:paypal_concept/components/sign_up_screen/form_component.dart';
import 'package:paypal_concept/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Image.asset(
                      'assets/images/paypal-login-screen-landscape-logo.png'),
                  height: 30,
                ),
                SizedBox(
                  height: 30,
                ),
                SignUpFormComponent(),
                SizedBox(
                  height: 24,
                ),
                Container(
                  child: Center(
                    child: InkWell(
                      child: Text(
                        'Already have an account? Sign in',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
                      ),
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => LoginScreen()));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  width: double.infinity,
                  height: 24,
                ),
              ],
            ),
            padding: EdgeInsets.all(45),
            reverse: true,
          ),

          // resizeToAvoidBottomInset: false,
        ),
        onWillPop: () => Future.value(false));
  }
}
