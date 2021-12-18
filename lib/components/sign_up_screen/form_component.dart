import 'package:flutter/material.dart';

class SignUpFormComponent extends StatefulWidget {
  const SignUpFormComponent({Key? key}) : super(key: key);

  @override
  SignUpFormComponentState createState() {
    return SignUpFormComponentState();
  }
}

class SignUpFormComponentState extends State<SignUpFormComponent> {
  final _formKey = GlobalKey<FormState>();

  // ERROR FIELDS
  String fullNameErrorMessage = "";
  String emailIdErrorMessage = "";
  String usernameErrorMessage = "";
  String password1ErrorMessage = "";
  String password2ErrorMessage = "";

  void errorMessageSetter(String fieldName, String message) {
    setState(() {
      switch (fieldName) {
        case 'FULL-NAME':
          fullNameErrorMessage = message;
          break;
        case 'EMAIL-ID':
          emailIdErrorMessage = message;
          break;
        case 'USERNAME':
          usernameErrorMessage = message;
          break;
        case 'PASSWORD1':
          password1ErrorMessage = message;
          break;
        case 'PASSWORD2':
          password2ErrorMessage = message;
          break;
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
          // input field for FULL-NAME starts here
          Container(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter some text';
                  errorMessageSetter(
                      'FULL-NAME', 'you must provide your Full Name');
                } else {
                  errorMessageSetter('FULL-NAME', "");
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
                hintText: "full name",
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
          if (fullNameErrorMessage != '')
            Container(
              child: Text(
                "\t\t\t\t$fullNameErrorMessage",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
            ),
          // input field for FULL-NAME ends here
          // input field for EMAIL-ADDRESS starts here
          Container(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter some text';
                  errorMessageSetter(
                      'EMAIL-ID', 'you must provide a valid email-id');
                } else {
                  errorMessageSetter('EMAIL-ID', "");
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
                hintText: "email address",
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
          if (emailIdErrorMessage != '')
            Container(
              child: Text(
                "\t\t\t\t$emailIdErrorMessage",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
            ),
          // input field for EMAIL-ADDRESS ends here
          // input field for USERNAME starts here
          Container(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter some text';
                  errorMessageSetter('USERNAME', 'provide a username');
                } else {
                  errorMessageSetter('USERNAME', "");
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
                hintText: "username",
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
          if (usernameErrorMessage != '')
            Container(
              child: Text(
                "\t\t\t\t$usernameErrorMessage",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
            ),
          // input field for USERNAME ends here
          // input field for PASSWORD starts here
          Container(
            child: TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter some text';
                  errorMessageSetter('PASSWORD1', 'password cannot be empty');
                } else {
                  errorMessageSetter('PASSWORD1', "");
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
          if (password1ErrorMessage != '')
            Container(
              child: Text(
                "\t\t\t\t$password1ErrorMessage",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
            ),
          // input field for PASSWORD ends here
          // input field for PASSWORD-CONFIRMATION starts here
          Container(
            child: TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter some text';
                  errorMessageSetter('PASSWORD2', 'password cannot be empty');
                } else {
                  errorMessageSetter('PASSWORD2', "");
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
                hintText: "re-enter password",
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
          if (password2ErrorMessage != '')
            Container(
              child: Text(
                "\t\t\t\t$password2ErrorMessage",
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
            ),
          // input field for PASSWORD-CONFIRMATION ends here
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (fullNameErrorMessage != "" ||
                            emailIdErrorMessage != "" ||
                            usernameErrorMessage != "" ||
                            password1ErrorMessage != "" ||
                            password2ErrorMessage != "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Please provide all required details'),
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
                    child: Text('Create Account'),
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
