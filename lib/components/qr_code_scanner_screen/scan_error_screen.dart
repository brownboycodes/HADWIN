import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ScanErrorScreen extends StatefulWidget {
  const ScanErrorScreen({Key? key}) : super(key: key);

  @override
  State<ScanErrorScreen> createState() => _ScanErrorScreenState();
}

class _ScanErrorScreenState extends State<ScanErrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController scanErrorAnimationController;

  @override
  void initState() {
    super.initState();
    scanErrorAnimationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    scanErrorAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffedf2f4),
      appBar: AppBar(
        title: Text("Error"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xff243656),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
          width: double.infinity,
          child: Column(
     
            children: [
              SizedBox(
                height: 100,
              ),
              Lottie.network(
                  'https://assets6.lottiefiles.com/packages/lf20_4fewfamh.json',
                  width: 300,
                  height: 300,
              
                  controller: scanErrorAnimationController,
                  onLoaded: (composition) {
                scanErrorAnimationController.duration = composition.duration;
                scanErrorAnimationController.forward();
                scanErrorAnimationController.repeat(reverse: true);
              }),
              Text(
                "Code not recognized",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              )
            ],
          )),
    );
  }
}
