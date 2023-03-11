import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:hadwin/hadwin_components.dart';


class AppCreatorInfoScreen extends StatelessWidget {
  const AppCreatorInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'brownboycodes',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff243656),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height - 180,
            
            child: FutureBuilder<Map<String, dynamic>>(
                future: getData(urlPath:  "/about/brownboycodes"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> socials =
                        snapshot.data!['socialNetworkingProfiles']
                            .map<Widget>((social) => RawMaterialButton(
                                  onPressed: () {
                                    launchExternalURL(social['url']);
                                  },
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  fillColor: Colors.transparent,
                                  focusColor: null,
                                  hoverColor: null,
                                  splashColor: null,
                                  highlightColor: null,
                                  focusElevation: 0,
                                  hoverElevation: 0,
                                  disabledElevation: 0,
                                  highlightElevation: 0,
                                  constraints: BoxConstraints(
                                      minWidth: 64.0,
                                      minHeight: 64.0,
                                      maxWidth: 64.0,
                                      maxHeight: 64.0),
                                  child: Image.network(
                                        '${ApiConstants.baseUrl}/dist/images/brownboycodes/social_icons/colorable/${social['avatar']}',
                                      ),
                                    
                                ))
                            .toList();

                    return Wrap(
                        direction: Axis.vertical,
                        runAlignment: WrapAlignment.center,
                        spacing: 8.4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 64,
                              backgroundColor: Color(0xffF5F7FA),
                              child: ClipOval(
                                child: AspectRatio(
                                  aspectRatio: 1.0 / 1.0,
                                  child: Image.network(
                                    '${ApiConstants.baseUrl}/dist/images/hadwin_images/attributions/${snapshot.data!['avatar']}',
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )),
                          Text(
                            snapshot.data!['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 96,
                            child: Text(
                              snapshot.data!['bio'],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 10,
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  Wrap(
                                    direction: Axis.vertical,
                                    spacing: 10,
                                    children: socials,
                                  ),
                                  Text(
                                    '@brownboycodes',
                                    style: TextStyle(fontSize: 24),
                                  )
                                ]),
                          ),
                        ]);
                  } else {
                    return _loadingTile(context);
                  }
                }),
          )),
        ],
      ),
    );
  }

  Widget _loadingTile(BuildContext context) {
    List<Widget> socials = List.generate(
        4,
        (index) => Container(
              child: FadeShimmer(
                radius: 16.18,
                height: 64,
                width: 64,
                fadeTheme: FadeTheme.light,
              ),
              padding: EdgeInsets.all(2),
            ));

    return Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
           Container(
        child: FadeShimmer.round(
          size: 128,
          fadeTheme: FadeTheme.light,
        ),
        padding: EdgeInsets.all(5),
      ),
          Container(
      child: FadeShimmer(
        radius: 16.18,
        height: 28,
        width: 120,
        fadeTheme: FadeTheme.light,
      ),
      padding: EdgeInsets.all(2),
    ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 96,
            child: Container(
      child: FadeShimmer(
        radius: 16.18,
        height: 20,
        width: 130,
        fadeTheme: FadeTheme.light,
      ),
      padding: EdgeInsets.all(2),
    ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 10,
                    children: socials,
                  ),
                  Container(
      child: FadeShimmer(
        radius: 16.18,
        height: 24,
        width: 96,
        fadeTheme: FadeTheme.light,
      ),
      padding: EdgeInsets.all(2),
    )
                ]),
          ),
        ]);
  }

 

}
