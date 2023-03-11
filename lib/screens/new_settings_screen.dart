import 'package:flutter/material.dart';
import 'package:hadwin/hadwin_components.dart';



class NewSettingsScreen extends StatelessWidget {
  NewSettingsScreen({Key? key}) : super(key: key);

  final AppBar appBar = AppBar(
    title: Text('Settings'),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xff243656),
    elevation: 0,
  );


  @override
  Widget build(BuildContext context) {
    Column appSettings = Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 180,
            child: AppSettingsComponent(),
          ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: appSettings,
    );
  }
}
