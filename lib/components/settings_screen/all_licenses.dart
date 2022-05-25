import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hadwin/components/settings_screen/license_data.dart';
import 'package:hadwin/utilities/slide_right_route.dart';

class AllLicenses extends StatelessWidget {
  const AllLicenses({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Licenses',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xff243656),
          elevation: 0,
        ),
        body: Column(children: [
          Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6.18,
            children: [
              
              Image.asset('assets/images/hadwin_system/hadwin-logo.png',
                  height: 48, width: 48),
                  Image.asset('assets/images/hadwin_system/hadwin-name.png',
                  height: 48),
              Text('1.0.0',style: TextStyle(color: Color(0xff243656))),
              FlutterLogo(
                size: 36,
              ),
              Text('Powered by Flutter',style: TextStyle(color: Color(0xff243656)),),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
              child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 180,
                  child: FutureBuilder<List<LicenseEntry>>(
                      future: LicenseRegistry.licenses.toList(),
                    
                      builder: (BuildContext context,
                          AsyncSnapshot<List<LicenseEntry>> snapshot) {
                      
                        if (snapshot.hasData) {
                          final allLicenceNames = snapshot.data!
                              .map((e) => e.packages.first)
                              .toList();
                          final uniqueLicences =
                              allLicenceNames.toSet().toList();
                         

                          return ListView.separated(
                              itemBuilder: (context, index) {
                                var licenseCount = allLicenceNames
                                    .where((element) =>
                                        element == uniqueLicences[index])
                                    .length;

                                var licenseData = snapshot.data!
                                    .where((e) =>
                                        e.packages.first ==
                                        uniqueLicences[index])
                                    .map((e) => e.paragraphs)
                                    .toList();
                                var suffix =
                                    licenseCount > 1 ? 'licenses' : 'license';
                                return ListTile(
                                  title: Text(
                                    uniqueLicences[index],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    "$licenseCount $suffix",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onTap: () {
                                 
                                    Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: LicenseData(
                                          licenseName: uniqueLicences[index],
                                          licenseData: licenseData,
                                        )));
                                  },
                                );
                              },
                              separatorBuilder: (_, b) => Divider(
                                    height: 6,
                                    color: Colors.grey.shade300,
                                  ),
                              itemCount: uniqueLicences.length);
                        } else {
                          return ListView.separated(
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(left: 8.4,right: 8.4,top: 3.6,bottom: 3.6),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100
                                        .withOpacity(0.1618),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: ListTile(
                           
                                    title: Container(
                                      child: FadeShimmer(
                                          radius: 16.18,
                                          height: 18,
                                          width: 72,
                                          fadeTheme: FadeTheme.light,
                                        ),
                                    ),
                                    
                                    subtitle: FadeShimmer(
                                        radius: 16.18,
                                        height: 18,
                                        width: 48,
                                        fadeTheme: FadeTheme.light,
                                      ),
                                   
                                  ),
                                );
                              },
                              separatorBuilder: (_, b) => SizedBox(
                                    height: 3.6,
                                    
                                  ),
                              itemCount: 9);
                        }
                      }))),
        ]));
  }

}
