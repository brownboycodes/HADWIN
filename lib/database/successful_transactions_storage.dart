import 'dart:convert';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SuccessfulTransactionsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _successfulTransactionsFile async {
    final path = await _localPath;
    return File('$path/hadwin_successful_transactions.json');
  }

  Future<bool> initializeSuccessfulTransactions() async {
    final file = await _successfulTransactionsFile;

    try {
      final contents = await getSuccessfulTransactions();
      if (contents.containsKey('transactions')) {
       //* pre-existing transactions loaded
        return true;
      } else {
        return file
            .writeAsString(jsonEncode({"transactions": []}))
            .then((value) {
          //* the transactions file has been initialized
          return true;
        });
      
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getSuccessfulTransactions() async {
    try {
      final file = await _successfulTransactionsFile;

      final contents = await file.readAsString();
      var decodedFile = jsonDecode(contents);
      return decodedFile;
    } catch (e) {
      return {"localDBError": "unable to parse data"};
    }
  }

  Future<bool> updateSuccessfulTransactions(
      Map<String, dynamic> transactionReceipt) async {
    try {
      final file = await _successfulTransactionsFile;

      final contents = await file.readAsString();

      var decodedFile = jsonDecode(contents);
      decodedFile['transactions'].add(transactionReceipt);

      return file.writeAsString(jsonEncode(decodedFile)).then((value) {
        //* transactions updated
        return true;
      });
     
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFile() async {
    try {
      final file = await _successfulTransactionsFile;

      await file.delete();
      //* THE LOCAL TRANSACTIONS FILE HAS BEEN DELETED
      return true;
    } catch (e) {
      //* THE LOCAL TRANSACTIONS FILE HAS NOT BEEN DELETED
      return false;
    }
  }

  Future<bool> resetLocallySavedTransactions() async {
    try {
      final file = await _successfulTransactionsFile;

      return file.writeAsString(jsonEncode({"transactions": []})).then((value) {
       //* RESET TRANSACTIONS FILE SUCCESSFUL
        return true;
      });
    } catch (e) {
      //* //* RESET TRANSACTIONS FILE UNSUCCESSFUL
      return false;
    }
  }
}
