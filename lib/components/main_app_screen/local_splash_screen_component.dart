import 'package:flutter/material.dart';

class LocalSplashScreenComponent extends StatelessWidget {
  const LocalSplashScreenComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff2f73b9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/hadwin_system/hadwin-splash-screen-logo.png',
            height: 128.0,
          ),
        ],
      ),
    );
  }
}
