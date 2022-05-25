import 'package:flutter/material.dart';
import 'package:hadwin/components/main_app_screen/tabbed_layout_component.dart';
import 'package:hadwin/database/cards_storage.dart';
import 'package:hadwin/database/login_info_storage.dart';
import 'package:hadwin/database/successful_transactions_storage.dart';
import 'package:hadwin/database/user_data_storage.dart';
import 'package:hadwin/providers/user_login_state_provider.dart';
import 'package:hadwin/utilities/make_api_request.dart';
import 'package:hadwin/utilities/display_error_alert.dart';
import 'package:provider/provider.dart';

class LoginFormComponent extends StatefulWidget {
  const LoginFormComponent({Key? key}) : super(key: key);

  @override
  LoginFormComponentState createState() {
    return LoginFormComponentState();
  }
}

class LoginFormComponentState extends State<LoginFormComponent> {
  LoginInfoStorage loginInfoStorage = LoginInfoStorage();
  final _formKey = GlobalKey<FormState>();
  String errorMessage1 = "";
  String errorMessage2 = "";
  String userInput = "";
  String password = "";

  void errorMessageSetter(int fieldNumber, String message) {
    setState(() {
      if (fieldNumber == 1) {
        errorMessage1 = message;
      } else {
        errorMessage2 = message;
      }
    });
  }

  Future<bool> _saveLoggedInUserData(
      String loggedInUserAuthKey, Map<String, dynamic> user) async {
    try {
      final userIsSaved = await Future.wait([
        UserDataStorage().saveUserData(user),
        loginInfoStorage.setPersistentLoginData(
            user['id'].toString(), loggedInUserAuthKey)
      ]);

      if (mounted) {
        Provider.of<UserLoginStateProvider>(context, listen: false)
            .setAuthKeyValue(loggedInUserAuthKey);
        Provider.of<UserLoginStateProvider>(context, listen: false)
            .initializeBankBalance(user);

        if (userIsSaved[0] && userIsSaved[1]) {
          debugPrint("user data saved");
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  void tryLoggingIn() async {
    final dataReceived = await sendData(
        urlPath: "/hadwin/v3/user/login",
        data: {"userInput": userInput, "password": password});
    if (dataReceived.keys.join().toLowerCase().contains("error")) {
      showErrorAlert(context, dataReceived);
    } else {
      final status = await Future.wait([
        _saveLoggedInUserData(
            dataReceived['authorization_token'], dataReceived['user']),
        CardsStorage()
            .initializeAvailableCards(dataReceived['authorization_token']),
        SuccessfulTransactionsStorage().initializeSuccessfulTransactions()
      ]);

      if (status[0] == true && status[1] == true && status[2] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
                content: Text("Login Successful"),
                backgroundColor: Colors.green))
            .closed
            .then((value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => TabbedLayoutComponent(
                          userData: dataReceived['user'],
                        )),
                (route) => false));
      }
    }
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
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  errorMessageSetter(
                      1, 'you must provide a email-id or username');
                } else {
                  errorMessageSetter(1, "");
                
                  setState(() {
                    userInput = value;
                  });
                }

                return null;
              },
              autocorrect: false,
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
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6.18,
                      spreadRadius: 0.618,
                      offset: Offset(-4, -4),
                      // color: Colors.white38
                      color: Color(0xFFF5F7FA)
                      ),
                  BoxShadow(
                      blurRadius: 6.18,
                      spreadRadius: 0.618,
                      offset: Offset(4, 4),

                      color: Colors.blueGrey.shade100
                      // color: Color(0xFFF5F7FA)
                      )
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
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => _validateLoginDetails(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  errorMessageSetter(2, 'password cannot be empty');
                } else {
                  errorMessageSetter(2, "");
                  setState(() {
                    password = value;
                  });
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
                      // blurRadius: 6.18,
                      spreadRadius: 0.618,
                      blurRadius: 6.18,
                      // spreadRadius: 6.18,
                      offset: Offset(-4, -4),
                      // color: Colors.white38
                      color: Color(0xFFF5F7FA)
                      ),
                  BoxShadow(
                      blurRadius: 6.18,
                      // spreadRadius: 6.18,
                      spreadRadius: 0.618,
                      offset: Offset(4, 4),

                      color: Colors.blueGrey.shade100
                      // color: Color(0xFFF5F7FA)
                      )
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
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
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
                onPressed: _validateLoginDetails,
                child: Text(
                  'Log in',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                )),
          ),
        ],
      ),
    );
  }

  void _validateLoginDetails() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      if (errorMessage1 != "" || errorMessage2 != "") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please provide all required details'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            onVisible: tryLoggingIn,
            content: Text('Processing...'),
            backgroundColor: Colors.blue));
      }
    }
  }
}
