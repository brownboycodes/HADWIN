import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadwin/components/add_card_screen/card_flipper.dart';
import 'package:hadwin/components/add_card_screen/card_processing_screen.dart';

import 'package:hadwin/utilities/card_identifier.dart';
import 'package:hadwin/utilities/slide_right_route.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen>
    with SingleTickerProviderStateMixin {
  late List<Widget> cardInputFields;
  late ItemScrollController _cardInputDataController;
  late TextEditingController _cardNumberInputController;
  late TextEditingController _expiryDateInputController;
  late TextEditingController _cvvInputController;
  late TextEditingController _cardHolderInputController;

  late CardFlippingController cardFlipper;

  late FocusScopeNode cardDetailsFocusNodes;
  late AnimationController cardSwitcher;
  late Animation<double> sides;

  Map<String, String> cardDetails = {
    'cardNumber': '',
    'expiryDate': '',
    'cvv': '',
    'cardHolder': ''
  };

  int _currentStep = 0;
  String cardBrand = "default";
  Image currentCardFrontSideImage = Image.asset(
    'assets/images/card_flow_assets/default-frontside.png',
    key: ValueKey(0),
  );
  late Image currentCardBackSideImage;

  @override
  void initState() {
    super.initState();
    _cardInputDataController = ItemScrollController();
    _cardNumberInputController = TextEditingController(text: "");
    _expiryDateInputController = TextEditingController(text: "");
    _cvvInputController = TextEditingController(text: "");
    _cardHolderInputController = TextEditingController(text: "");

    cardFlipper = CardFlippingController();

    cardDetailsFocusNodes = FocusScopeNode();
    cardInputFields = getCardInputFields();
    cardSwitcher =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));

    sides = Tween<double>(begin: 0.0, end: 1.0).animate(cardSwitcher);

    currentCardBackSideImage =
        Image.asset('assets/images/card_flow_assets/$cardBrand-backside.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(currentCardFrontSideImage.image, context);
    precacheImage(currentCardBackSideImage.image, context);
  }

  @override
  void dispose() {
    _cardNumberInputController.dispose();
    _expiryDateInputController.dispose();
    _cvvInputController.dispose();
    _cardHolderInputController.dispose();
    cardSwitcher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardFrontSide = Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 900),
          reverseDuration: Duration(seconds: 210),
          switchInCurve: Curves.linear,
          child: currentCardFrontSideImage,
          transitionBuilder: (Widget child, sides) {
            return AnimatedBuilder(
              animation: sides,
              child: child,
              builder: (BuildContext context, Widget? child) {
                return ClipPath(
                  clipper: CardClipperLeftToRight2(sideValue: sides.value),
                  child: child,
                );
              },
            );
          },
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: Text(
            _cardNumberInputController.text.isEmpty
                ? "XXXX XXXX XXXX 1234"
                : _cardNumberInputController.text,
            style: TextStyle(
              fontFamily: 'OCRA',
              color: Colors.white,
              fontSize: 19,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                ),
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 8.0,
                  color: cardLabelColors[cardBrand]!.withOpacity(0.5),
                ),
              ],
            ),
          ),
        )),
        Positioned(
            left: 16,
            bottom: 30,
            child: Wrap(
              direction: Axis.vertical,
              spacing: 3.6,
              children: [
                Text(
                  'CARD HOLDER',
                  style: GoogleFonts.inconsolata(
                    color: cardLabelColors[cardBrand],
                    fontSize: 11,
                  ),
                ),
                Text(
                  _cardHolderInputController.text.isEmpty
                      ? "JOHN DOE"
                      : _cardHolderInputController.text.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'OCRA',
                    color: Colors.white,
                    fontSize: 14,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                      ),
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 8.0,
                        color: cardLabelColors[cardBrand]!.withOpacity(0.5),
                      ),
                    ],
                  ),
                )
              ],
            )),
        Positioned(
            right: 18,
            bottom: 30,
            child: Wrap(
              direction: Axis.vertical,
              spacing: 3.6,
              children: [
                Text(
                  'EXPIRES',
                  style: GoogleFonts.inconsolata(
                    color: cardLabelColors[cardBrand],
                    fontSize: 11,
                  ),
                ),
                Text(
                  _expiryDateInputController.text.isEmpty
                      ? "MM/YY"
                      : _expiryDateInputController.text,
                  style: TextStyle(
                    fontFamily: 'OCRA',
                    color: Colors.white,
                    fontSize: 14,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                      ),
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 8.0,
                        color: cardLabelColors[cardBrand]!.withOpacity(0.5),
                      ),
                    ],
                  ),
                )
              ],
            ))
      ],
    );

    Widget cardBackSide = Stack(
      children: [
        currentCardBackSideImage,
        Positioned(
            right: 27,
            top: (MediaQuery.of(context).size.width - 60) * .22,
            child: Text(
              _cvvInputController.text.isEmpty
                  ? "123"
                  : _cvvInputController.text,
              style: GoogleFonts.inconsolata(
                color: Colors.black,
                fontSize: 18,
              ),
            ))
      ],
    );

    Widget cardHoldingSpace = Container(
        // width: double.infinity,
        width: MediaQuery.of(context).size.width,
        height: 9 * MediaQuery.of(context).size.width / 16,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: CardFlipper(
            cardFlippingController: cardFlipper,
            transitionDuration: Duration(milliseconds: 960),
            frontSide: cardFrontSide,
            backSide: cardBackSide));

    Widget cardInputFieldsSpace = Container(
      // width: double.infinity,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      height: 100,
      color: Colors.white,
      child: FocusScope(
          node: cardDetailsFocusNodes,
          child: ScrollablePositionedList.separated(
            scrollDirection: Axis.horizontal,
            itemScrollController: _cardInputDataController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cardInputFields.length,
            itemBuilder: (context, index) {
              return Opacity(
                opacity: _currentStep == index ? 1 : 0.3,
                child: cardInputFields[index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              width: 14,
            ),
          )),
    );
    Widget goBackToPreviousStepButton = TextButton(
        onPressed: backToPreviousStep,
        child: Text(
          "BACK",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ));
    Widget goToNextStepButton = TextButton(
        onPressed: proceedToNextStep,
        child: Text(
          "NEXT",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ));
    Widget completedAllStepsButton = TextButton(
        onPressed: _tryAddingCard,
        child: Text(
          "DONE",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ));

    Widget cardInputNavigationButtons = Container(
      color: Colors.green,
      // width: double.infinity,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(0),
      child: _currentStep < 3
          ? Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                if (_currentStep > 0) goBackToPreviousStepButton,
                goToNextStepButton
              ],
            )
          : _cardHolderInputController.text.isNotEmpty
              ? completedAllStepsButton
              : goBackToPreviousStepButton,
    );


    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            backgroundColor: Color(0xffedf2f4),
            appBar: MediaQuery.of(context).viewInsets.bottom == 0
                ? AppBar(
                    title: Text("Add New Card"),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Color(0xff243656),
                    leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back)),
                  )
                : null,
            body:
            //  SingleChildScrollView(
            //     reverse: true,
            Container(
              height: MediaQuery.of(context).size.height,
              // width: double.infinity,
              width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                        bottom: MediaQuery.of(context).viewInsets.bottom == 0
                            ? null
                            : 0,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height:
                                MediaQuery.of(context).viewInsets.bottom == 0
                                    ? 16
                                    : 84,
                          ),
                          cardHoldingSpace,
                          SizedBox(
                            height: MediaQuery.of(context).size.height>700?36:18,
                          ),
                          cardInputFieldsSpace,
                          cardInputNavigationButtons
                        ]))
                  ],
                ))));
  }

  void _tryAddingCard() {
    FocusManager.instance.primaryFocus?.unfocus();

    Future.delayed(
        Duration(milliseconds: 200),
        (() => Navigator.push(
            context,
            SlideRightRoute(
                page: CardProcessingScreen(
              cardDetails: {
                'cardNumber': _cardNumberInputController.text,
                'expiryDate': _expiryDateInputController.text,
                'cvv': _cvvInputController.text,
                'cardHolder': _cardHolderInputController.text,
                'cardBrand': cardBrand
              },
            )))));
  }

  //? FUNCTION FOR MOVING TO NEXT STEP
  void proceedToNextStep() {
    int temporaryStepStore = _currentStep;
    if (_currentStep < cardInputFields.length - 1) {
      temporaryStepStore++;

      if (temporaryStepStore == 2 || temporaryStepStore == 3) {
        cardFlipper.flipCard().then((bool flipped) {
          if (flipped) {
            setState(() {
              _currentStep = temporaryStepStore;
            });
            _cardInputDataController
                .scrollTo(
                    index: _currentStep,
                    duration: Duration(microseconds: 1),
                    curve: Curves.easeIn)
                .whenComplete(() => cardDetailsFocusNodes.nextFocus());
          }
        });
      } else {
        setState(() {
          _currentStep = temporaryStepStore;
        });
        _cardInputDataController
            .scrollTo(
                index: _currentStep,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeIn)
            .whenComplete(() => cardDetailsFocusNodes.nextFocus());
      }
    }
  }

//? FUNCTION FOR RETURNING TO PREVIOUS STEP
  void backToPreviousStep() {
    int temporaryStepStore = _currentStep;
    if (_currentStep > 0) {
      temporaryStepStore -= 1;

      if (temporaryStepStore == 2 || temporaryStepStore == 1) {
        cardFlipper.flipCard().then((bool flipped) {
          if (flipped) {
            setState(() {
              _currentStep = temporaryStepStore;
            });
            _cardInputDataController
                .scrollTo(
                    index: _currentStep,
                    duration: Duration(microseconds: 1),
                    curve: Curves.easeIn)
                .whenComplete(() => cardDetailsFocusNodes.previousFocus());
          }
        });
      } else {
        setState(() {
          _currentStep = temporaryStepStore;
        });
        _cardInputDataController
            .scrollTo(
                index: _currentStep,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeIn)
            .whenComplete(() => cardDetailsFocusNodes.previousFocus());
      }
    }
  }

//? FUNCTION FOR FORMATTING CARD NUMBER
  String _formatCardNumber(String currentCardNumber) {
    String formattedCardNumber = "";
    if (cardBrand == 'american-express' ||
        RegExp(r'^3[47]').hasMatch(currentCardNumber)) {
      for (var i = 0; i < currentCardNumber.length; i++) {
        formattedCardNumber += currentCardNumber[i];
        if (i == 3 || i == 9) {
          formattedCardNumber += ' ';
        }
      }
    } else {
      for (var i = 0; i < currentCardNumber.length; i++) {
        formattedCardNumber += currentCardNumber[i];
        if ((i + 1) % 4 == 0) {
          formattedCardNumber += ' ';
        }
      }
    }
    return formattedCardNumber.trim();
  }

  Map<String, int> cardNumberMaxLengths = {
    'american-express': 15,
    'discover': 16,
    'maestro': 16,
    'mastercard': 16,
    'visa': 16,
  };

  Map<String, Color> cardLabelColors = {
    'american-express': Colors.transparent,
    'discover': Color(0xffc9184a),
    'maestro': Color(0xff90e0ff),
    'mastercard': Color(0xff590d22),
    'visa': Color(0xffe0aaff),
    'default': Colors.white
  };

  List<Widget> getCardInputFields() {
    TextStyle inputLabelStyle = TextStyle(color: Colors.grey.shade600);
    return [
      Wrap(
        direction: Axis.vertical,
        children: [
          Text(
            "CARD NUMBER",
            style: inputLabelStyle,
          ),
          Container(
              color: Colors.transparent,
              width: 200,
              child: TextField(
                controller: _cardNumberInputController,
                enableSuggestions: false,
                showCursor: false,
                autofocus: true,
                autocorrect: false,
                autofillHints: null,
                onChanged: _onCardNumberChanged,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(19),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none),
              ))
        ],
      ),
      Wrap(
        direction: Axis.vertical,
        children: [
          Text("EXPIRY DATE", style: inputLabelStyle),
          Container(
              color: Colors.transparent,
              width: 100,
              child: TextField(
                controller: _expiryDateInputController,
                showCursor: false,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: null,
                onChanged: _onExpiryDateChanged,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]|\/'))
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none),
              ))
        ],
      ),
      Wrap(
        direction: Axis.vertical,
        children: [
          Text("CVV/CVC", style: inputLabelStyle),
          Container(
              color: Colors.transparent,
              width: 100,
              child: TextField(
                controller: _cvvInputController,
                onChanged: (value) {
                  setState(() {});
                  if (value.length == 3) {
                    proceedToNextStep();
                  }
                },
                showCursor: false,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: null,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none),
              ))
        ],
      ),
      Wrap(
        direction: Axis.vertical,
        children: [
          Text("CARD HOLDER'S NAME", style: inputLabelStyle),
          Container(
              color: Colors.transparent,
              width: 200,
              child: TextField(
                controller: _cardHolderInputController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                showCursor: false,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: null,
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (_) => _tryAddingCard(),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(19),
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]|\s'))
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none),
              ))
        ],
      )
    ];
  }

  void _onExpiryDateChanged(value) {
    final formattedDate = formatExpiryDate(value);
    setState(() {});
    if (RegExp(r"\b\d{1,2}\/\d{2}\b").hasMatch(formattedDate)) {
      proceedToNextStep();
    }
  }

  void _onCardNumberChanged(value) {
    var cursorPos = _cardNumberInputController.selection.base.offset;

    String formattedCardNumber = _formatCardNumber(value.replaceAll(' ', ''));
    _cardNumberInputController.value = TextEditingValue(
      text: formattedCardNumber,
      selection: TextSelection.fromPosition(TextPosition(
          offset: (formattedCardNumber.length -
                  value.replaceAll(' ', '').length +
                  cursorPos)
              .toInt())),
    );
    setState(() {});
    String currentCardBrand = identifyCardShorter(value);
    if (currentCardBrand != cardBrand) {
      setState(() {
        cardBrand = currentCardBrand;
        if (cardBrand == 'default') {
          currentCardFrontSideImage = Image.asset(
            'assets/images/card_flow_assets/default-frontside.png',
            key: ValueKey(1),
          );

          currentCardBackSideImage = Image.asset(
              'assets/images/card_flow_assets/$cardBrand-backside.png');
        } else {
          int randomValueKey = Random().nextInt(20) + 2;
          currentCardFrontSideImage = Image.asset(
            'assets/images/card_flow_assets/$cardBrand-frontside.png',
            key: ValueKey(randomValueKey),
          );

          currentCardBackSideImage = Image.asset(
              'assets/images/card_flow_assets/$cardBrand-backside.png');
        }
        precacheImage(currentCardFrontSideImage.image, context);
        precacheImage(currentCardBackSideImage.image, context);
      });
    }

    if (cardBrand != 'default' &&
        _cardNumberInputController.text.replaceAll(' ', '').length ==
            cardNumberMaxLengths[cardBrand]) {
      proceedToNextStep();
    }
  }

  String formatExpiryDate(String value) {
    int cursorPos = _expiryDateInputController.selection.base.offset;

    String formattedDate = value;
    String suffix = _expiryDateInputController.text.substring(cursorPos);
    if (cursorPos > 0) {
      cursorPos -= 1;
    }
    String prefix = _expiryDateInputController.text.substring(0, cursorPos);
    String lastInput = value.isEmpty ? '' : value[cursorPos];
    int lastInputLength = lastInput.length;

    if (value.isNotEmpty && value[cursorPos] == '/' && suffix.isEmpty) {
      formattedDate = prefix + suffix;
      lastInputLength = 0;
      //? formattedDate goes in here
    } else if (RegExp(r'^\d{1,2}$').hasMatch(value)) {
      if (value.length == 1 && int.parse(value) > 1) {
        formattedDate = prefix + lastInput + '/' + suffix;
        lastInputLength += 1;
      } else if (value.length == 1 && int.parse(value) <= 1) {
        formattedDate = prefix + lastInput + suffix;
      } else if (value.length == 2 &&
          (int.parse(value) >= 1 && int.parse(value) <= 12)) {
        formattedDate = prefix + lastInput + '/' + suffix;
        lastInputLength += 1;
      } else {
        formattedDate = prefix + suffix;
        lastInputLength = 0;
      }
    } else if (RegExp(r'^\d{1,2}\/\d{1,2}$').hasMatch(value)) {
      int currentYear = DateTime.now().year % 2000;
      int cardExpiryYear = int.parse(value.split('/').last);

      if (cardExpiryYear.toString().length == 1 &&
          cardExpiryYear >= currentYear % 10) {
        formattedDate = prefix + lastInput + suffix;
      } else if (RegExp(r'^\d{1,2}\/\d{2}$').hasMatch(value) &&
          cursorPos == 0) {
        formattedDate = prefix + suffix;
        lastInputLength = 0;
      } else if (cardExpiryYear.toString().length == 2 &&
          cardExpiryYear >= currentYear) {
        formattedDate = prefix + lastInput + suffix;
      } else {
        formattedDate = prefix + suffix;
        lastInputLength = 0;
      }
    } else {
      formattedDate = "";
      lastInputLength = 0;
      cursorPos = 0;
    }

    _expiryDateInputController.text = formattedDate;
    _expiryDateInputController.selection = TextSelection(
        baseOffset: cursorPos + lastInputLength,
        extentOffset: cursorPos + lastInputLength);

    return formattedDate;
  }
}

class CardClipperLeftToRight2 extends CustomClipper<Path> {
  double sideValue;
  CardClipperLeftToRight2({required this.sideValue});
  @override
  Path getClip(Size size) {
    Path path = Path();

    if (0.3 + sideValue < 1) {
      path.lineTo(size.width * (0.3 + sideValue), 0);
      path.lineTo(size.width * sideValue, size.height);
      path.lineTo(0, size.height);
    } else {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height * sideValue);
      path.lineTo(size.width * sideValue, size.height);
      path.lineTo(0, size.height);
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
