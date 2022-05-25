import 'package:concentric_transition/concentric_transition.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadwin/database/hadwin_user_device_info_storage.dart';
import 'package:hadwin/screens/login_screen.dart';
import 'package:hadwin/utilities/hadwin_markdown_viewer.dart';
import 'package:hadwin/utilities/slide_right_route.dart';

class PageData {
  final String? title;

  final Image? mediaContent;
  final Color bgColor;
  final Color textColor;
  final Widget? optionalWidget;

  PageData(
      {this.title,
      this.mediaContent,
      this.bgColor = Colors.white,
      this.textColor = Colors.black,
      this.optionalWidget});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late List<PageData> pages;
  late Widget getStarted;
  UserDeviceInfoStorage userDeviceInfoStorage = UserDeviceInfoStorage();

  @override
  void initState() {
    super.initState();

    getStarted = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: completedOrientation,
            child: Text(
              'Get Started',
              style: TextStyle(fontSize: 27, color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: Color(0xfffe5845),
                padding: EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.5))),
          ),
        ),
        InkWell(
          onTap: _getDocs,
          child: Text(
            "read the documentation\nif you need help",
            style: GoogleFonts.roboto(
              color: Colors.white,
              letterSpacing: 0.0,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
    pages = [
      PageData(
          // textColor: Color(0xFFe8f9ec),
          mediaContent: null,
          textColor: Colors.white,
          bgColor: Color(0xff6baef2),
          title:
              "\nHADWIN is a prototype of a fund-transfer platform.\nHence, it cannot be used for making real payments or receiving real money as of now\nHADWIN was created from designs found on Dribbble, Behance & Pinterest\n\n\n\n\n\n\t(Swipe right or tap the circle below)"),
      PageData(
        mediaContent: Image.asset(
            'assets/images/onboarding_assets/wfh-mohamed-chahin-bg-less.png'),
        title:
            "still... it's a relatively well functioning app as for something built right out of a small apartment",
        bgColor: Color(0xff3385c0),
        textColor: Colors.white,
      ),
      PageData(
          mediaContent: Image.asset(
              'assets/images/onboarding_assets/online-shopping-yuliia-osadcha-bg-less.png'),
          bgColor: Color(0xff23b2f8),
          textColor: Colors.white,
          optionalWidget: getStarted),
    ];
  }

  void _getDocs() {
    Navigator.push(
        context,
        SlideRightRoute(
            page: HadWinMarkdownViewer(
                screenName: 'Docs',
                urlRequested:
                    'https://raw.githubusercontent.com/brownboycodes/HADWIN/master/docs/HADWIN_WIKI.md')));
  }

  void completedOrientation() async {
    bool isSaved = await userDeviceInfoStorage.initializeInstallationStatus();
    if (isSaved) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return LoginScreen();
      // }));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    }
  }

  List<Color> get colors => pages.map((p) => p.bgColor).toList();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ConcentricPageView(
          colors: colors,
          radius: 30,
          curve: Curves.ease,
          duration: Duration(seconds: 2),
          itemCount: pages.length,
          itemBuilder: (index, value) {
            // PageData page = pages[index % pages.length];
            PageData page = pages[index];
            return Column(children: [
            
              Container(
                child: Theme(
                  data: ThemeData(
                    textTheme: TextTheme(
                      headline6: TextStyle(
                          color: page.textColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Helvetica',
                          letterSpacing: 0.0,
                          fontSize: 15),
                      subtitle2: TextStyle(
                        color: page.textColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                      bodyText2: GoogleFonts.poppins(
                        color: page.textColor,
                        letterSpacing: 0.0,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  child: PageCard(page: page),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

class PageCard extends StatelessWidget {
  final PageData page;

  const PageCard({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Column(
        children: <Widget>[
          _buildPicture(context),
          if (page.optionalWidget == null && page.mediaContent != null)
            SizedBox(height: 24),
          if (page.title != null) _buildText(context),
          if (page.optionalWidget != null) page.optionalWidget!
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context) {
   
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Text(
        page.title!,
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildPicture(
    BuildContext context,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width - 64,
      margin: EdgeInsets.only(
        top: 120,
      ),
      child: page.mediaContent,
    );
  }
}
