import 'dart:math';

import 'package:flutter/material.dart';

class CardFlipper extends StatefulWidget {
  final Widget frontSide, backSide;
  final Duration transitionDuration;
  final CardFlippingController? cardFlippingController;
  CardFlipper(
      {Key? key,
      required this.frontSide,
      required this.backSide,
      required this.transitionDuration,
      this.cardFlippingController})
      : super(key: key);

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper>
    with SingleTickerProviderStateMixin {
  late AnimationController cardFlippingController;

  late Animation<double> flipAnimation;
  Widget? displayedCard;
  bool isFacingUp = true;
  double skewFactor = 0;
  double defaultSkew = 0;

  TweenSequence<double> leftToRight = TweenSequence(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 360, end: 180), weight: 3),
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 180, end: 190), weight: 2),
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 190, end: 180), weight: 1),
  ]);

  TweenSequence<double> rightToLeft = TweenSequence(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 180), weight: 3),
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 180, end: 170), weight: 2),
    TweenSequenceItem<double>(
        tween: Tween<double>(begin: 170, end: 180), weight: 1),
  ]);

  @override
  void initState() {
    super.initState();


    cardFlippingController =
        AnimationController(vsync: this, duration: widget.transitionDuration);

    if (isFacingUp) {
      flipAnimation = leftToRight.animate(cardFlippingController);
    } else {
      flipAnimation = rightToLeft.animate(cardFlippingController);
    }

    cardFlippingController.addListener(() {
      if (cardFlippingController.isCompleted) {
        cardFlippingController.reset();

        setState(() {
          isFacingUp = !isFacingUp;
          if (isFacingUp) {
            flipAnimation = leftToRight.animate(cardFlippingController);
          } else {
            flipAnimation = rightToLeft.animate(cardFlippingController);
          }
          defaultSkew = 0;
          skewFactor = 0;
        });
      } else if (cardFlippingController.isAnimating) {
        setState(() {
          defaultSkew = 0.001;
          skewFactor = flipAnimation.value;
        });
        setImage();
      }

    });
    widget.cardFlippingController?.cardState = this;
  }

  @override
  void dispose() {
    cardFlippingController.dispose();
    super.dispose();
  }

  void setImage() {
    if (isFacingUp) {
      if (skewFactor >= 270) {
        setState(() {
          displayedCard = widget.frontSide;

        });
      } else {
        setState(() {
          displayedCard = Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.000)
              ..rotateY(180 / 180 * pi),
            alignment: Alignment.center,
            child: widget.backSide,
          );

        });
      }
    } else {
      if (skewFactor <= 90) {
        setState(() {
          displayedCard = widget.backSide;

        });
      } else {
        setState(() {
          displayedCard = Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.000)
              ..rotateY(180 / 180 * pi),
            alignment: Alignment.center,
            child: widget.frontSide,
          );

        });
      }
      
    }
   
  }

  Future<bool> flipCard() async {
   
    return cardFlippingController.forward().then((value) => true);
  
  }

  @override
  Widget build(BuildContext context) {
    if (isFacingUp && skewFactor == 0) {
      displayedCard = widget.frontSide;
    } else if (!isFacingUp && skewFactor == 0) {
      displayedCard = widget.backSide;
    }


    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, defaultSkew)
        ..rotateY(skewFactor / 180 * pi),
      alignment: Alignment.center,
      child: displayedCard,
    );

  }


}

class CardFlippingController {
  _CardFlipperState? cardState;
  Future<bool> flipCard() async => await cardState!.flipCard();
}
