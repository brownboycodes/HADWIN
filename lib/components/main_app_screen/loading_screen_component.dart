import 'package:flutter/material.dart';

class LoadingScreenComponent extends StatelessWidget {
  const LoadingScreenComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 64,
            width: 64,
            child: CircularProgressIndicator(),
          ),
          Padding(padding: EdgeInsets.all(10), child: Text("Loading..."))
        ],
      ),
    );
  }
}
