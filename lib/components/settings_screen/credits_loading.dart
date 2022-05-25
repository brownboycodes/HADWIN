import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

Widget _creditsloadingTile(BuildContext context) {
  List<Widget> socialLinks = List.generate(
    6,
    (index) => Container(
      child: FadeShimmer(
        radius: 16.18,
        height: 48,
        width: 48,
        fadeTheme: FadeTheme.light,
      ),
      padding: EdgeInsets.all(2),
    ),
  );
  return Container(
    width: MediaQuery.of(context).size.width - 10,

    padding: EdgeInsets.all(16),
    
    decoration: BoxDecoration(
      
        color: Colors.blueGrey.shade100.withOpacity(0.1618),
        borderRadius: BorderRadius.all(Radius.circular(16.18))),

    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 6.18),
    child: Wrap(
      direction: Axis.vertical,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 48,
          padding: EdgeInsets.all(6.18),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Wrap(direction: Axis.vertical, children: [
                Container(
                  child: FadeShimmer(
                    radius: 16.18,
                    height: 27,
                    width: 96,
                    fadeTheme: FadeTheme.light,
                  ),
                  padding: EdgeInsets.all(2),
                ),
                Container(
                  child: FadeShimmer(
                    radius: 16.18,
                    height: 20,
                    width: 72,
                    fadeTheme: FadeTheme.light,
                  ),
                  padding: EdgeInsets.all(2),
                ),
              ]),
              Container(
                child: FadeShimmer(
                  radius: 16.18,
                  height: 64,
                  width: 64,
                  fadeTheme: FadeTheme.light,
                ),
           
              ),
            ],
          ),
        ),
        Container(
          child: FadeShimmer(
            radius: 16.18,
            height: 16,
            width: 96,
            fadeTheme: FadeTheme.light,
          ),
          padding: EdgeInsets.all(2),
        ),
        Container(
          height: 72,
          width: MediaQuery.of(context).size.width - 48,

          padding: EdgeInsets.all(0),

          color: Colors.transparent,
          child: ListView.separated(
  
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => socialLinks[index],
              separatorBuilder: (_, b) => SizedBox(
                    width: 16.18,
                  ),
              itemCount: socialLinks.length),
        )
      ],
    ),
  );
}

Widget creditsLoadingList(int items, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.all(5), child: _creditsloadingTile(context)),
      itemCount: items,
    ),
  );
}
