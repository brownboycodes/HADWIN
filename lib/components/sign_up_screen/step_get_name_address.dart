import 'package:flutter/material.dart';

class StepGetNameAddress extends StatefulWidget {
  final LabeledGlobalKey<FormState> nameAddressFormKey;
  final Function updateSignUpDetails;

  final Function registrationDetails;
  final Function proceedToNextStep;
  const StepGetNameAddress(
      {Key? key,
      required this.updateSignUpDetails,
      required this.nameAddressFormKey,
      required this.registrationDetails,
      required this.proceedToNextStep})
      : super(key: key);

  @override
  _StepGetNameAddressState createState() => _StepGetNameAddressState();
}

class _StepGetNameAddressState extends State<StepGetNameAddress> {
  String fullName = "";
  String fullNameErrorMessage = "";
  String residentialAddress = "";
  String residentialAddressErrorMessage = "";

  @override
  void initState() {
    super.initState();
    Map<String, String> signUpDetails = widget.registrationDetails();
    if (mounted) {
      setState(() {
        fullName = signUpDetails['fullname']!;
        residentialAddress = signUpDetails['address']!;
      });
    }
  }

  @override
  void dispose() {
    // widget.nameAddressFormKey.currentState?.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.nameAddressFormKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: TextFormField(
                initialValue: fullName,
                validator: _validateName,
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
                  hintText: "full name",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
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
            if (fullNameErrorMessage != '')
              Container(
                child: Text(
                  "\t\t\t\t$fullNameErrorMessage",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                width: double.infinity,
              ),

            Container(
              width: double.infinity,
              child: TextFormField(
                initialValue: residentialAddress,
                validator: _validateAddress,
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
                  hintText: "residential address",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                style: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => widget.proceedToNextStep(),
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
            if (residentialAddressErrorMessage != '')
              Container(
                child: Text(
                  "\t\t\t\t$residentialAddressErrorMessage",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                width: double.infinity,
              ),
            // input field for RESIDENTIAL-ADDRESS ends here
          ],
        ));
  }

  void errorMessageSetter(String fieldName, String message) {
    setState(() {
      switch (fieldName) {
        case 'FULL-NAME':
          fullNameErrorMessage = message;
          break;

        case 'RESIDENTIAL-ADDRESS':
          residentialAddressErrorMessage = message;
          break;
      }
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      errorMessageSetter('FULL-NAME', 'you must provide your full name');
    } else if (value.length > 100) {
      errorMessageSetter(
          'FULL-NAME', 'name cannot contain more than 100 characters');
    } else {
      errorMessageSetter('FULL-NAME', "");

      widget.updateSignUpDetails('fullname', value);
    }

    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      errorMessageSetter(
          'RESIDENTIAL-ADDRESS', 'you must provide your residential address');
    } else if (value.length > 300) {
      errorMessageSetter('RESIDENTIAL-ADDRESS',
          'address cannot contain more than 300 characters');
    } else {
      errorMessageSetter('RESIDENTIAL-ADDRESS', "");

      widget.updateSignUpDetails('address', value);
    }

    return null;
  }
}
