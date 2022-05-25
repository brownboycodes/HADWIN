import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

Widget _contactLoadingTile() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        child: FadeShimmer.round(
          size: 72,
          fadeTheme: FadeTheme.light,
        ),
        padding: EdgeInsets.all(5),
      ),
      Column(
        children: [
          Container(
            child: FadeShimmer(
              height: 21,
              width: 200,
              fadeTheme: FadeTheme.light,
            ),
            padding: EdgeInsets.all(5),
          ),
          Container(
            child: FadeShimmer(
              height: 18,
              width: 180,
              fadeTheme: FadeTheme.light,
            ),
            padding: EdgeInsets.all(5),
          )
        ],
      ),
      
    ],
  );
}

Widget contactsLoadingList(int items) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (_, index) =>
          Padding(padding: EdgeInsets.all(5), child: _contactLoadingTile()),
      itemCount: items,
    ),
  );
}
