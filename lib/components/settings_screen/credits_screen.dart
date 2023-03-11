import 'package:flutter/material.dart';

import 'package:hadwin/hadwin_components.dart';


class CreditsScreen extends StatelessWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Credits',
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
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 180,
                child: FutureBuilder<Map<String, dynamic>>(
                    future: getData(urlPath: "/hadwin/app"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          itemBuilder: (_, index) => Container(
                            width: MediaQuery.of(context).size.width - 10,

                            color: Colors.transparent,
                            margin: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 6.18),
                            child: Wrap(
                              direction: Axis.vertical,
                              children: [
                                SizedBox(
                                  height: 6.4,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 10,
                                  padding: EdgeInsets.all(6.18),
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                          direction: Axis.vertical,
                                          spacing: 10,
                                          children: [
                                            Text(
                                              snapshot.data!['attributions']
                                                  [index]['header'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff343a40)),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  105,
                                              child: Text(
                                                  snapshot.data!['attributions']
                                                      [index]['name'],
                                                  style: TextStyle(
                                                      fontSize: 22.2,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Color(0xff343a40))),
                                            )
                                          ]),
                                    
                                      RawMaterialButton(
                                        onPressed: () {
                                          if ( snapshot.data!['attributions']
                                                  [index]['website'] is String) {
                                            launchExternalURL(
                                              snapshot.data!['attributions']
                                                  [index]['website']);
                                          }
                                        },
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 0,
                                        fillColor: Colors.transparent,
                                        splashColor: null,
                                        hoverColor: null,
                                        constraints: BoxConstraints(
                                            minWidth: 64.0,
                                            minHeight: 64.0,
                                            maxWidth: 64.0,
                                            maxHeight: 64.0),
                                        child: Image.network(
                                            '${ApiConstants.baseUrl}/dist/images/hadwin_images/attributions/${snapshot.data!['attributions'][index]['avatar']}'),
                              
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16.18))),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 7.2),
                                  child: Text(
                                      snapshot.data!['attributions'][index]
                                                  ['name']
                                              .contains('Unsplash')
                                          ? "The Photographers:"
                                          : 'Find ${snapshot.data!['attributions'][index]['name'].split(' ').first} on:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff343a40))),
                                ),
                                Container(
                                  height: 72,
                                  width: MediaQuery.of(context).size.width - 10,

                                  color: Colors.transparent,
                                  child: ListView.separated(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7.2),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (_, socialIndex) =>
                                          RawMaterialButton(
                                            onPressed: () {
                                              launchExternalURL(
                                                  snapshot.data!['attributions']
                                                          [index]['socials']
                                                      [socialIndex]['url']);
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
                                                minWidth: 48.0,
                                                minHeight: 48.0,
                                                maxWidth: 48.0,
                                                maxHeight: 48.0),
                                            child: Image.network(
                                                '${ApiConstants.baseUrl}/dist/images/brownboycodes/social_icons/${snapshot.data!['attributions'][index]['socials'][socialIndex]['avatar']}'),
                                
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.18))),
                                          ),
                                      separatorBuilder: (_, b) => SizedBox(
                                            width: 16.18,
                                          ),
                                      itemCount: snapshot
                                          .data!['attributions'][index]
                                              ['socials']
                                          .length),
                                ),
                                SizedBox(
                                  height: 6.4,
                                )
                              ],
                            ),
                          ),
                          separatorBuilder: (_, b) => Divider(
                
                            thickness: 16,
                            color: Colors.blueGrey.shade50.withOpacity(0.618),
                          ),
                          itemCount: snapshot.data!['attributions'].length,
                        );
                      } else {
                        return creditsLoadingList(6, context);
                      }
                    })),
          ),
        ],
      ),
    );
  }

}
