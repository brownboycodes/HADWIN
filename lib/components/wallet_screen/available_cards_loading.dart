import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

Widget _availableCardsLoadingTile() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        child: FadeShimmer(
          height: 48,
          width: 64,
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

Widget availableCardsLoadingList(int items) {
  return ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (_, index) =>
          Padding(padding: EdgeInsets.all(5), child: _availableCardsLoadingTile()),
      itemCount: items,
    )
  ;
}
