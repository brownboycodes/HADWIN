import 'package:flutter/material.dart';

class LoginFormComponent extends StatefulWidget {
  const LoginFormComponent({Key? key}) : super(key: key);

  @override
  LoginFormComponentState createState() {
    return LoginFormComponentState();
  }
}

class LoginFormComponentState extends State<LoginFormComponent> {
  final _formKey = GlobalKey<FormState>();
  String errorMessage1 = "";
  String errorMessage2 = "";

  void errorMessageSetter(int fieldNumber, String message) {
    setState(() {
      if (fieldNumber == 1) {
        errorMessage1 = message;
      } else {
        errorMessage2 = message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter some text';
                  errorMessageSetter(
                      1, 'you must provide a email-id or username');
                } else {
                  errorMessageSetter(1, "");
                }

                return null;
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "username or email address",
                hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
              style: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            // color: Colors.white,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6.18,
                      spreadRadius: 0.618,
                      offset: Offset(-4, -4),
                      color: Colors.white38),
                  BoxShadow(
                      blurRadius: 6.18,
                      spreadRadius: 0.618,
                      offset: Offset(4, 4),
                      // color: Color(0xFF929BAB),
                      color: Colors.blueGrey.shade100)
                ]),
          ),
          if (errorMessage1 != '')
            Container(
              child: Text(
                "\t\t\t\t$errorMessage1",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
            ),
          Container(
            child: TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter some text';
                  errorMessageSetter(2, 'password cannot be empty');
                } else {
                  errorMessageSetter(2, "");
                }
                return null;
              },
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: "password",
                hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6.18,
                      spreadRadius: 0.618,
                      offset: Offset(-4, -4),
                      color: Colors.white38),
                  BoxShadow(
                      blurRadius: 6.18,
                      spreadRadius: 0.618,
                      offset: Offset(4, 4),
                      // color: Color(0xFF929BAB)
                      color: Colors.blueGrey.shade100)
                ]),
          ),
          if (errorMessage2 != '')
            Container(
              child: Text(
                "\t\t\t\t$errorMessage2",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
            ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (errorMessage1 != "" || errorMessage2 != "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Please enter proper input details'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Login Successful'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Log in'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0070BA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
                width: double.infinity,
                height: 64,
              )),
        ],
      ),
    );
  }
}
