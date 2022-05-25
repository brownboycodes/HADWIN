import 'package:flutter/material.dart';
import 'package:hadwin/database/successful_transactions_storage.dart';
import 'package:hadwin/providers/user_login_state_provider.dart';

class LiveTransactionsProvider with ChangeNotifier {
  late UserLoginStateProvider _userLoginStateProvider;

  List<dynamic> _successfulTransactionsInQueue = [];
  List<String> _unreadTransactionsList = [];
  int _transactionRequests = 0;
  LiveTransactionsProvider();
  
  List<dynamic> get successfulTransactionsInQueue =>
      _successfulTransactionsInQueue;
  int get unreadTransactions => _unreadTransactionsList.length;
  int get transactionRequests => _transactionRequests;
  

  void update(UserLoginStateProvider userLoginStateProvider) {
    _userLoginStateProvider = userLoginStateProvider;
  }

  //? to keep track of successful "debit / paid" transactions
  Future<bool> updateSuccessfulTransactions(
      Map<String, dynamic> transactionReceipt) async {
        //? server time modified to client time
    transactionReceipt['transactionDate'] = "${DateTime.now()}";
   
    //* transaction added
    
    bool isSaved = await SuccessfulTransactionsStorage()
        .updateSuccessfulTransactions(transactionReceipt);
    if (isSaved) {
      _userLoginStateProvider.updateBankBalance(
          transactionReceipt['transactionType'],
          transactionReceipt['transactionAmount']);
      notifyListeners();
    }
  
    return isSaved;
  }

  //? to keep track of successful "credit / received" transactions
  void updateSuccessfulTransactionsInQueue(
      Map<String, dynamic> transactionReceipt) {
    _successfulTransactionsInQueue.add(transactionReceipt);
    notifyListeners();
  }

  void addUnreadTransaction(String transactionId) {
    _unreadTransactionsList.add(transactionId);
    notifyListeners();
  }

  void removeUnreadTransaction(String transactionId) {
    if (_unreadTransactionsList.contains(transactionId)) {
      _unreadTransactionsList.remove(transactionId);
      notifyListeners();
    }
  }

  void updateTransactionRequests() async {
    if (_successfulTransactionsInQueue.length > 0) {
      Map<String, dynamic> transactionAtTop =
          _successfulTransactionsInQueue.first;
   
      bool isSaved = await updateSuccessfulTransactions(transactionAtTop);
      if (isSaved) {
        addUnreadTransaction(transactionAtTop['transactionID']);
        _successfulTransactionsInQueue.removeAt(0);
        _transactionRequests++;
      }
      notifyListeners();
    }
  }

  Future<bool> resetTransactionsInState() async {
    try {
      _successfulTransactionsInQueue = [];
      _unreadTransactionsList = [];
      _transactionRequests = 0;
      return true;
    } catch (e) {
      return false;
    }
  }
}
