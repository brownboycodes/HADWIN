import 'package:flutter/material.dart';
import 'package:hadwin/hadwin_components.dart';

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
            AssetConstants.splashScreenLogo,
            height: 128.0,
          ),
        ],
      ),
    );
  }
}
