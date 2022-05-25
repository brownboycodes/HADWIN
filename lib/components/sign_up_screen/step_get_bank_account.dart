import 'package:flutter/material.dart';

class StepGetBankAccount extends StatefulWidget {
  final LabeledGlobalKey<FormState> bankAccountFormKey;
  final Function updateSignUpDetails;
  final Function showConfirmSignUpButton;
  final Function registrationDetails;
  final Function finalStepProccessing;
  const StepGetBankAccount(
      {Key? key,
      required this.updateSignUpDetails,
      required this.registrationDetails,
      required this.bankAccountFormKey,
      required this.showConfirmSignUpButton,
      required this.finalStepProccessing})
      : super(key: key);

  @override
  _StepGetBankAccountState createState() => _StepGetBankAccountState();
}

class _StepGetBankAccountState extends State<StepGetBankAccount> {
  String bankAccount = "";
  String bankAccountErrorMessage = "";
  @override
  void initState() {
    super.initState();
    Map<String, String> signUpDetails = widget.registrationDetails();
    if (mounted) {
      setState(() {
        bankAccount = signUpDetails['bankAccount']!;
      });
    }
  }

  @override
  void dispose() {
    // widget.bankAccountFormKey.currentState?.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.bankAccountFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: TextFormField(
                initialValue: bankAccount,
                onChanged: _toggleSignUpButtonVisibility,
                validator: _validateBankAccount,
                autofocus: mounted,
                autocorrect: false,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.finalStepProccessing();
                  }
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
                  hintText: "bank account number",
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
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(4, 4),
                        color: Colors.blueGrey.shade100)
                  ]),
            ),
            if (bankAccountErrorMessage != '')
              Container(
                child: Text(
                  "\t\t\t\t$bankAccountErrorMessage",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
              ),
          ],
        ));
  }

  void errorMessageSetter(String message) {
    setState(() {
      bankAccountErrorMessage = message;
    });
  }

  String? _validateBankAccount(String? value) {
    if (value == null || value.isEmpty) {
      errorMessageSetter('you must provide a valid Bank Account number');
    } else if (value.length > 25) {
      errorMessageSetter(
          'Bank Account number cannot contain more than 25 characters');
    } else {
      errorMessageSetter("");

      // widget.updateSignUpDetails('bankAccount', value);
      setState(() {
        bankAccount = value;
      });
    }

    return null;
  }

  void _toggleSignUpButtonVisibility(String value) {
    widget.updateSignUpDetails('bankAccount', value);
    if (value.isNotEmpty) {
      widget.showConfirmSignUpButton(true);
    } else {
      widget.showConfirmSignUpButton(false);
    }
  }
}
