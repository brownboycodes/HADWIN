import 'package:flutter/material.dart';
import 'package:paypal_concept/components/login_screen/form_component.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 64,
            ),
            Image.asset('assets/images/paypal-login-screen-landscape-logo.png'),
            SizedBox(
              height: 64,
            ),
            LoginFormComponent(),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Center(
                child: InkWell(
                  child: Text(
                    'Having trouble logging in?',
                    style: TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
                  ),
                  onTap: () {},
                ),
              ),
              width: double.infinity,
              height: 36,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Center(
                child: InkWell(
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 14, color: Color(0xFF929BAB)),
                  ),
                  onTap: () {},
                ),
              ),
              width: double.infinity,
              height: 36,
            )
          ],
        ),
        padding: EdgeInsets.all(45),
        reverse: true,
      ),

      // resizeToAvoidBottomInset: false,
    );
  }
}
