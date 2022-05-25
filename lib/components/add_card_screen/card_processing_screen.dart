import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:hadwin/database/cards_storage.dart';

class CardProcessingScreen extends StatefulWidget {
  const CardProcessingScreen({Key? key, required this.cardDetails})
      : super(key: key);
  final Map<String, String> cardDetails;
  @override
  State<CardProcessingScreen> createState() => _CardProcessingScreenState();
}

class _CardProcessingScreenState extends State<CardProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController cardProcessingAnimationController;
  bool exitScreen = false;
  bool showMessage = false;
  late Widget processStatusAnimation;
  String title = "Processing...";
  Widget processStatusText2 = SizedBox(
    height: 48,
    key: ValueKey(0),
  );
  Widget processStatusText = SizedBox(
    height: 48,
    key: ValueKey(0),
  );

  void toggleMessageVisibility() {
    if (cardProcessingAnimationController.isAnimating) {
      if (cardProcessingAnimationController.value > .5 &&
          showMessage == false) {
        setState(() {
          showMessage = true;
          processStatusText2 = processStatusText;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    cardProcessingAnimationController = AnimationController(
      vsync: this,
    );
    cardProcessingAnimationController.addListener(toggleMessageVisibility);
    processStatusAnimation = Container(
      color: Colors.transparent,
      width: 300,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      String cardErrorMessage = await verifyCardDetails();

      if (cardErrorMessage.isEmpty) {
        setState(() {
          processStatusAnimation = Container(
              color: Colors.transparent,
              width: 300,
              child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_uub9r8ta.json',
                  repeat: false,
                  controller: cardProcessingAnimationController,
                  onLoaded: (composition) {
                cardProcessingAnimationController.duration =
                    composition.duration;
                cardProcessingAnimationController.forward();
              }));
          processStatusText = SizedBox(
              height: 48,
              key: ValueKey(1),
              child: Text(
                'card was added',
                style:
                    GoogleFonts.poppins(fontSize: 16, color: Color(0xff343a40)),
                textAlign: TextAlign.center,
              ));
          title = "Successful!";
        });

        CardsStorage().updateAvailableCards(widget.cardDetails);
      } else {
        setState(() {
          processStatusAnimation = Container(
              color: Colors.transparent,
              width: 136,
              child: Lottie.network(
                  'https://assets3.lottiefiles.com/packages/lf20_tl52xzvn.json',
                  repeat: false,
                  controller: cardProcessingAnimationController,
                  onLoaded: (composition) {
                cardProcessingAnimationController.duration =
                    composition.duration;
                cardProcessingAnimationController.forward();
              }));
          processStatusText = SizedBox(
              height: 48,
              key: ValueKey(1),
              child: Text(
                cardErrorMessage,
                style:
                    GoogleFonts.poppins(fontSize: 16, color: Color(0xff343a40)),
                textAlign: TextAlign.center,
              ));
          title = "Failed";
        });
      }
    });

    cardProcessingAnimationController.addListener(listenForExit);
  }

  void listenForExit() {
    if (cardProcessingAnimationController.isCompleted) {
      Future.delayed(Duration(seconds: 2, milliseconds: 500), (() {
        int count = 0;
        if (mounted) {
          Navigator.of(context).popUntil((_) => count++ >= 2);
        }
      }));
    }
  }

  Map<String, String> cardBrands = {
    'american-express': 'American Express',
    'diners-club': 'Diners Club',
    'discover': 'DISCOVER',
    'jcb': 'JCB',
    'maestro': 'Maestro',
    'mastercard': 'MasterCard',
    'rupay': 'RuPay',
    'solo': 'SOLO',
    'switch': 'SWITCH',
    'union-pay': 'UnionPay',
    'visa': 'VISA',
  };

  Future<String> verifyCardDetails() async {
    var availableCards = await CardsStorage().readAvailableCards();

    List<dynamic> cardNumbers = availableCards['availableCards']
        .map((e) => e['cardNumber'].replaceAll(' ', ''))
        .toList();
   
    int totalErrors = 0;
    String cardErrorMessage = '';
    if (widget.cardDetails['cardNumber']!.isEmpty) {
      cardErrorMessage = 'card number not provided';
      totalErrors++;
    } else if (cardNumbers
        .contains(widget.cardDetails['cardNumber']!.replaceAll(' ', ''))) {
      cardErrorMessage = 'card is already present';
      totalErrors++;
    }

    if (widget.cardDetails['cardBrand'] == 'default' ||
        widget.cardDetails['cardBrand']!.isEmpty) {
      cardErrorMessage = 'card not recognized';
      totalErrors++;
    } else {
      setState(() {
        widget.cardDetails['cardBrand'] =
            cardBrands[widget.cardDetails['cardBrand']]!;
      });
    }

    if (widget.cardDetails['expiryDate']!.isEmpty) {
      cardErrorMessage = 'expiry date not provided';
      totalErrors++;
    } else if (!RegExp(r'\b\d{1,2}\/\d{2}\b')
        .hasMatch(widget.cardDetails['expiryDate']!)) {
      cardErrorMessage = 'format of expiry date is invalid';
      totalErrors++;
    } else if (RegExp(r'\b\d{1,2}\/\d{2}\b')
        .hasMatch(widget.cardDetails['expiryDate']!)) {
      List<String> expiryDate = widget.cardDetails['expiryDate']!.split('/');
      int currentYear = int.parse(DateTime.now().year.toString().substring(2));
      int currentMonth = DateTime.now().month;
      int cardMonth = int.parse(expiryDate.first);
      int cardYear = int.parse(expiryDate.last);
      if (cardYear < currentYear) {
        cardErrorMessage = 'card has already expired';
        totalErrors++;
      } else if (cardYear == currentYear && cardMonth < currentMonth) {
        cardErrorMessage = 'card has already expired';
        totalErrors++;
      } else if (cardMonth > 12 || cardMonth < 1) {
        cardErrorMessage = 'invalid month on expiry date';
        totalErrors++;
      }
    }
    if (widget.cardDetails['cvv']!.isEmpty) {
      cardErrorMessage = 'CVV not provided';
      totalErrors++;
    } else if (widget.cardDetails['cvv']!.length < 3) {
      cardErrorMessage = 'CVV is incomplete';
      totalErrors++;
    }
    if (widget.cardDetails['cardHolder']!.isEmpty) {
      cardErrorMessage = 'card holder\'s name not provided';
      totalErrors++;
    }

    if (totalErrors > 1) {
      cardErrorMessage = 'multiple errors';
    }
    return cardErrorMessage;
  }

  @override
  void dispose() {
    cardProcessingAnimationController.removeListener(listenForExit);
    cardProcessingAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        int count = 0;
        if (mounted) {
          Navigator.of(context).popUntil((_) => count++ >= 2);
        }
        return Future.value(false);
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
         backgroundColor: Color(0xfffcfcfc),
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(fontSize: 19),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xff243656),
          leading: IconButton(
              onPressed: goBackToWalletScreen, icon: Icon(Icons.arrow_back)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: double.infinity,
                height: 400,
                child: Center(
                    child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                      AnimatedSwitcher(
                        child: processStatusAnimation,
                        duration: Duration(milliseconds: 300),
                      ),
                      AnimatedSwitcher(
                        child: processStatusText2,
                        duration: Duration(milliseconds: 600),
                      ),
                    ])))
          ],
        ),
      ),
    );
  }

  void goBackToWalletScreen() {
    int count = 0;
    if (mounted) {
      Navigator.of(context).popUntil((_) => count++ >= 2);
    }
  }
}
