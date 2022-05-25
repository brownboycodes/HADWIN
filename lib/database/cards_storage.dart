import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:hadwin/utilities/make_api_request.dart';

class CardsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _cardsFile async {
    final path = await _localPath;
    return File('$path/hadwin_available_cards.json');
  }

  Future<Map<String, dynamic>> get randomCard async {
    var _availableCards = (await readAvailableCards())['availableCards'];

    return _availableCards[Random().nextInt(_availableCards.length)];
  }

  Future<bool> initializeAvailableCards(String userAuthKey) async {
    final file = await _cardsFile;
    try {
      final contents = await readAvailableCards();
      if (contents.containsKey('availableCards')) {
        //* pre-existing cards loaded
        return true;
      } else {
        try {
          Map<String, dynamic> availableCards = await getData(
              urlPath: "/hadwin/v1/available-cards", authKey: userAuthKey);
          if (availableCards.keys.join().toLowerCase().contains("error")) {
            return false;
          } else {
            return file.writeAsString(jsonEncode(availableCards)).then((value) {
              //* the cards have been saved in app memory
              return true;
            });
         
          }
        } catch (er) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> readAvailableCards() async {
    try {
      final file = await _cardsFile;

      final contents = await file.readAsString();

      return jsonDecode(contents);
    } catch (e) {
      return {"localDBError": "unable to parse data"};
    }
  }

  void updateAvailableCards(Map<String, dynamic> cardData) async {
    final file = await _cardsFile;

    final contents = await file.readAsString();

    var decodedFile = jsonDecode(contents);
    decodedFile['availableCards'].add(cardData);

    file
        .writeAsString(jsonEncode(decodedFile))
        .then((value) => print("new card added"));
  }

  Future<bool> deleteCard(String cardNumber) async {
    try {
      final file = await _cardsFile;

      final contents = await file.readAsString();

      var decodedFile = jsonDecode(contents)['availableCards'];

      List<dynamic> newCardsSet = decodedFile
          .where((card) =>
              card['cardNumber'].replaceAll(' ', '') !=
              cardNumber.replaceAll(' ', ''))
          .toList();
      return file
          .writeAsString(jsonEncode({'availableCards': newCardsSet}))
          .then((value) {
        //* card has been deleted
        return true;
      });
     
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFile() async {
    try {
      final file = await _cardsFile;

      await file.delete();
      //* THE LOCAL CARDS FILE HAS BEEN DELETED
      return true;
    } catch (e) {
     //* THE LOCAL CARDS FILE HAS NOT BEEN DELETED
      return false;
    }
  }

  Future<bool> resetLocallySavedCards() async {
    try {
      final file = await _cardsFile;

      return file.writeAsString(jsonEncode({"availableCards": []})).then((value) {
        //* RESET CARDS FILE SUCCESSFUL
        return true;
      });
    } catch (e) {
    //* RESET CARDS FILE UNSUCCESSFUL
      return false;
    }
  }
}
