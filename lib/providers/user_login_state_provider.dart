

import 'package:flutter/material.dart';
import 'package:hadwin/database/user_data_storage.dart';

class UserLoginStateProvider with ChangeNotifier {
  String _userLoginAuthKey = "";

  

  double _bankBalance = 0;

  String get userLoginAuthKey => _userLoginAuthKey;

  

  String get bankBalance {
    String stringifiedBankBalance = _bankBalance.toStringAsFixed(2);
    if (stringifiedBankBalance.split('.').last == '00') {
      return stringifiedBankBalance.split('.').first;
    } else {
      return stringifiedBankBalance;
    }
  }

  void setAuthKeyValue(String receivedAuthKey) {
    _userLoginAuthKey = receivedAuthKey;
    notifyListeners();
  
  }


  bool initializeBankBalance(Map<String, dynamic> userData) {
    _bankBalance = userData['bankDetails'].fold(
        0.0, (sum, account) => sum + double.parse(account['bankBalance']));
    notifyListeners();
    return true;
  }

  Future<bool> resetBankBalance() async{
    try {
      Map<String,dynamic> locallySavedUserData= await UserDataStorage().getUserData();
      _bankBalance = locallySavedUserData['bankDetails'].fold(
        0.0, (sum, account) => sum + double.parse(account['bankBalance']));
    notifyListeners();
    return true;
    } catch (e) {
      return false;
    }

  }

  void updateBankBalance(String transactionType, String transactionAmount) {
    if (transactionType == 'debit') {
      _bankBalance -= double.parse(transactionAmount);
    } else {
      _bankBalance += double.parse(transactionAmount);
    }
    //* bank balance updated
    notifyListeners();
  }
}
