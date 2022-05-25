import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:hadwin/components/fund_transfer_screen/transaction_receipt_screen.dart';
import 'package:hadwin/providers/live_transactions_provider.dart';
import 'package:hadwin/providers/user_login_state_provider.dart';
import 'package:hadwin/utilities/make_api_request.dart';
import 'package:hadwin/utilities/display_error_alert.dart';
import 'package:hadwin/utilities/slide_right_route.dart';
import 'package:provider/provider.dart';

class TransactionProcessingScreen extends StatefulWidget {
  final Map<String, dynamic> transactionReceipt;
  const TransactionProcessingScreen(
      {Key? key, required this.transactionReceipt})
      : super(key: key);

  @override
  _TransactionProcessingScreenState createState() =>
      _TransactionProcessingScreenState();
}

class _TransactionProcessingScreenState
    extends State<TransactionProcessingScreen> with TickerProviderStateMixin {
  late AnimationController transactionProcessingAnimationController;
  late AnimationController transactionExecutedAnimationController;
  late Map<String, dynamic> responseForTransaction;
  bool _exitScreen = false;
  
  Widget receiptButton = SizedBox(
    height: 36,
    key: ValueKey(0),
  );
  dynamic error = null;
  Map<String, dynamic>? _transactionStatusAnimation;
  @override
  void initState() {
    super.initState();
    transactionProcessingAnimationController = AnimationController(
      vsync: this,
      
    );
    transactionExecutedAnimationController = AnimationController(
      vsync: this,

      
    );
    double transactionAmount=double.parse(widget.transactionReceipt['transactionAmount']);
    if (transactionAmount<=0) {
      //? TRANSACTION FAILS DUE TO INVALID AMOUNT
        setState(() {
          error = 'none';
          _transactionStatusAnimation = {
            
            'url':
                'https://assets3.lottiefiles.com/packages/lf20_tl52xzvn.json',
            
            'width': 128.0,
            'text': 'transaction amount is invalid'
          };
          _exitScreen = true;
        });
    } else if (transactionAmount>0 && transactionAmount <=
        10000.00) {
      if (widget.transactionReceipt['transactionType'] == 'debit' &&
          transactionAmount >
              double.parse(
                  context.read<UserLoginStateProvider>().bankBalance)) {
        //? IN CASE TRANSACTION FAILS
        setState(() {
          error = 'none';
          _transactionStatusAnimation = {
            
            'url':
                'https://assets3.lottiefiles.com/packages/lf20_tl52xzvn.json',
            
            'width': 128.0,
            'text': 'transaction amount exceeds\navailable balance'
          };
          _exitScreen = true;
        });
      } else {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          executeTransaction();
        });
      }
    } else {
      //? IN CASE TRANSACTION FAILS
      setState(() {
        error = 'none';
        _transactionStatusAnimation = {
          
          'url': 'https://assets3.lottiefiles.com/packages/lf20_tl52xzvn.json',
          
          'width': 128.0,
          'text': 'Sorry,\n transfer of only \$10000\nallowed per transaction'
        };
        _exitScreen = true;
      });
    }
  }

  @override
  void dispose() {
    transactionProcessingAnimationController.dispose();
    transactionExecutedAnimationController.dispose();
    super.dispose();
  }

  void executeTransaction() async {
    String userAuthKey =
        Provider.of<UserLoginStateProvider>(context, listen: false)
            .userLoginAuthKey;
    responseForTransaction = await sendData(
        urlPath: "/hadwin/v2/execute-transaction",
        data: {
          'transactionReceipt': widget.transactionReceipt,
        },
        authKey: userAuthKey);
    
    if (responseForTransaction.keys.join().toLowerCase().contains("error")) {
      setState(() {
        error = responseForTransaction;
      });
    } else {
      
      setState(() {
        error = 'none';
      });
      if (responseForTransaction['transactionStatus'] == "successful") {
        if (responseForTransaction['transactionReceipt']['transactionType'] ==
            'debit') {
          //? FOR ---SUCCESSFUL--- PAYMENT

          Provider.of<LiveTransactionsProvider>(context, listen: false)
              .updateSuccessfulTransactions(
                  responseForTransaction['transactionReceipt']);

          Provider.of<LiveTransactionsProvider>(context, listen: false)
              .addUnreadTransaction(responseForTransaction['transactionReceipt']
                  ['transactionID']);

          setState(() {
            _transactionStatusAnimation = {
              'url':
                  'https://assets2.lottiefiles.com/packages/lf20_sonmjuir.json',
         
              'width': 360.0,
            };
          });
          transactionExecutedAnimationController.addListener(() {
            if (transactionExecutedAnimationController.isCompleted) {
              setState(() {
           
                receiptButton = SizedBox(
                  height: 36,
                  key: ValueKey(1),
                  child: OutlinedButton(
                      child: Text("View Transaction Receipt"),
                      style: OutlinedButton.styleFrom(
            
                        primary: Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            SlideRightRoute(
                                page: TransactionReceiptScreen(
                              transactionReceipt:
                                  responseForTransaction['transactionReceipt'],
                              transactionStatus:
                                  responseForTransaction['transactionStatus'],
                            )));
                      }),
                );
              });
            }
          });
        } else {
          //? FOR ---SUCCESSFUL--- TRANSACTION REQUEST
          Provider.of<LiveTransactionsProvider>(context, listen: false)
              .updateSuccessfulTransactionsInQueue(
                  responseForTransaction['transactionReceipt']);

          setState(() {
            transactionExecutedAnimationController =
                AnimationController(vsync: this, upperBound: 0.7083);
            _transactionStatusAnimation = {
              'url':
                  'https://assets1.lottiefiles.com/packages/lf20_vRx1sP.json',
       
              'width': 220.0,
              'text':
                  'Your request has been sent to\n${widget.transactionReceipt['transactionMemberName']}'
            };
            _exitScreen = true;
          });
        }
      } else {
        //? IN CASE TRANSACTION FAILS
        setState(() {
          _transactionStatusAnimation = {  
            'url':
                'https://assets3.lottiefiles.com/packages/lf20_tl52xzvn.json',        
            'width': 128.0,
            'text': 'Sorry,\nyour transaction failed'
          };
          _exitScreen = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      // backgroundColor: Color(0xffedf2f4),
       backgroundColor: Color(0xfffcfcfc),
      appBar: AppBar(
        title: Text(
          "Transaction Status",
          style: TextStyle(fontSize: 19),
        ),
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
         
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           

              Container(
                height: 400,
                width: double.infinity,
                child: Center(
                  child: Builder(builder: (context) {
                    if (error != null && error != 'none') {
                      WidgetsBinding.instance!.addPostFrameCallback(
                          (_) => showErrorAlert(context, error!));

                      return Wrap(
                        direction: Axis.vertical,
                        children: [
                         
                          Container(
                              color: Colors.transparent,
                              height: 300,
                              width: 300,
                              child: Lottie.network(
                                  'https://assets2.lottiefiles.com/packages/lf20_jxdtgpuk.json',
                                  controller:
                                      transactionProcessingAnimationController,
                                  onLoaded: (composition) {
                                transactionProcessingAnimationController
                                    .duration = composition.duration;
                                transactionProcessingAnimationController
                                    .forward();
                              }))
                        ],
                      );
                    } else if (error == 'none') {
                      transactionExecutedAnimationController.addListener(() {
                        if (transactionExecutedAnimationController
                                .isCompleted &&
                            _exitScreen) {
                          Future.delayed(
                              Duration(seconds: 2, milliseconds: 500), (() {
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          }));
                        }
                      });
                      transactionProcessingAnimationController.reset();
                      return Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                              color: Colors.transparent,
                              width: _transactionStatusAnimation!['width'],
                             
                              child: Lottie.network(
                                  _transactionStatusAnimation!['url'],
                                  repeat: false,
                                  controller:
                                      transactionExecutedAnimationController,
                                  onLoaded: (composition) {
                                transactionExecutedAnimationController
                                    .duration = composition.duration;
                                transactionExecutedAnimationController
                                    .forward();
                              })),
                          if (_transactionStatusAnimation!.containsKey('text'))
                            Text(
                              _transactionStatusAnimation!['text'],
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Color(0xff343a40)),
                              textAlign: TextAlign.center,
                            )
                        ],
                      );
                    } else {
                      return Wrap(
                        direction: Axis.vertical,
                        children: [
                          Container(
                              color: Colors.transparent,
                              height: 300,
                              width: 300,
                              child: Lottie.network(
                                  'https://assets2.lottiefiles.com/packages/lf20_jxdtgpuk.json',
                                  controller:
                                      transactionProcessingAnimationController,
                                  onLoaded: (composition) {
                                transactionProcessingAnimationController
                                    .duration = composition.duration;
                                transactionProcessingAnimationController
                                    .forward();
                              }))
                        ],
                      );
                    }
                  }),
                ),
              ),

            
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: receiptButton,
              )
            ],
          )),
    );
  }
}
