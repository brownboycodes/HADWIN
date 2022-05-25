import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

Widget _activityloadingTile() {
  Widget bar=Container(
            child: FadeShimmer(
              height: 18,
              width: 180,
              fadeTheme: FadeTheme.light,
            ),
            padding: EdgeInsets.all(5),
          );
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        child: FadeShimmer.round(
          size: 64,
          fadeTheme: FadeTheme.light,
        ),
        padding: EdgeInsets.all(5),
      ),
      Column(
        children: [
          bar,
          bar
        ],
      ),
      Column(
        children: [
          Container(
            child: FadeShimmer(
              height: 18,
              width: 30,
              fadeTheme: FadeTheme.light,
            ),
            padding: EdgeInsets.all(5),
          ),
          Container(
            height: 23,
            padding: EdgeInsets.all(5),
          )
        ],
      )
    ],
  );
}

Widget activitiesLoadingList(int items) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (_, index) =>
          Padding(padding: EdgeInsets.all(5), child: _activityloadingTile()),
      itemCount: items,
    ),
  );
}
