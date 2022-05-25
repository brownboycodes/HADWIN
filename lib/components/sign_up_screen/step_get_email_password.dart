import 'package:flutter/material.dart';

class StepGetEmailPassword extends StatefulWidget {
  final LabeledGlobalKey<FormState> emailPasswordFormKey;
  final Function updateSignUpDetails;

  final Function registrationDetails;
  final Function proceedToNextStep;
  const StepGetEmailPassword(
      {Key? key,
      required this.updateSignUpDetails,
      required this.registrationDetails,
      required this.emailPasswordFormKey,
      required this.proceedToNextStep})
      : super(key: key);

  @override
  _StepGetEmailPasswordState createState() => _StepGetEmailPasswordState();
}

class _StepGetEmailPasswordState extends State<StepGetEmailPassword> {
  String emailId = "";
  String password = "";
  String emailIdErrorMessage = "";
  String passwordErrorMessage = "";
  RegExp validEmailFormat = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    super.initState();
    Map<String, String> signUpDetails = widget.registrationDetails();
    if (mounted) {
      setState(() {
        emailId = signUpDetails['emailId']!;
        password = signUpDetails['password']!;
      });
    }
  }

  @override
  void dispose() {
    // widget.emailPasswordFormKey.currentState?.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.emailPasswordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: emailId,
                validator: _validateEmailId,
                autofocus: mounted,
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
                  hintText: "email address",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                keyboardType: TextInputType.emailAddress,
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
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(4, 4),
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
            Container(
              width: double.infinity,
              child: TextFormField(
                initialValue: password,
                validator: _validatePassword,
                autofocus: mounted,
                autocorrect: false,
                obscureText: true,
                enableSuggestions: false,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => widget.proceedToNextStep(),
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
                        color: Colors.blueGrey.shade100)
                  ]),
            ),
            if (passwordErrorMessage != '')
              Container(
                child: Text(
                  "\t\t\t\t$passwordErrorMessage",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
              ),
          ],
        ));
  }

  void errorMessageSetter(String fieldName, String message) {
    setState(() {
      switch (fieldName) {
        case 'EMAIL-ID':
          emailIdErrorMessage = message;
          break;

        case 'PASSWORD1':
          passwordErrorMessage = message;
          break;
      }
    });
  }

  String? _validateEmailId(String? value) {
    if (value == null || value.isEmpty) {
      errorMessageSetter('EMAIL-ID', 'you must provide a valid email-id');
    } else if (!validEmailFormat.hasMatch(value)) {
      errorMessageSetter('EMAIL-ID', 'format of your email address is invalid');
    } else {
      errorMessageSetter('EMAIL-ID', "");
      widget.updateSignUpDetails('emailId', value);
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      errorMessageSetter('PASSWORD1', 'password cannot be empty');
    } else {
      errorMessageSetter('PASSWORD1', "");

      widget.updateSignUpDetails('password', value);
    }
    return null;
  }
}
