import 'package:flutter/material.dart';
import 'package:hadwin/hadwin_components.dart';



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
                  height: 16,
                ),
                Container(
                  child: Image.asset('assets/images/hadwin_system/hadwin-logo-with-name.png'),
                  height: 30,
                ),
                SizedBox(
                  height: 30,
                ),
               
                SignUpSteps(),
                SizedBox(
                  height: 27,
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
                      
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  width: double.infinity,
                  height: 16,
                ),
                SizedBox(
                  height: 3,
                )
              ],
            ),
            padding: EdgeInsets.all(45),
         
          ),

        ),
        onWillPop: () => Future.value(false));
  }
}
