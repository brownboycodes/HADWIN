import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LoginInfoStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _userLoginDataFile async {
    final path = await _localPath;
    return File('$path/hadwin_user_login_info_storage.json');
  }

  Future<bool> setPersistentLoginData(String userId, String authToken) async {
    try {
      final file = await _userLoginDataFile;
     //* THE USER_ID AND AUTHENTICATION_TOKEN HAS BEEN SAVED
      return file
          .writeAsString(jsonEncode({'userId': userId, 'authToken': authToken}))
          .then((value) {
       //* THE USER_ID HAS BEEN SAVED
        return true;
      });
    } catch (e) {
      //* THE USER_ID AND AUTHENTICATION_TOKEN COULD NOT BE SAVED
      return false;
    }
  }

  Future<Map<String, dynamic>> get getPersistentLoginData async {
    try {
      final file = await _userLoginDataFile;
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return {'userId': null, 'authToken': null};
    }
  }

  Future<bool> deleteFile() async {
    try {
      final file = await _userLoginDataFile;

      await file.delete();
      //* THE LOGIN DATA FILE HAS BEEN DELETED
      return true;
    } catch (e) {
      //* THE LOGIN DATA FILE HAS NOT BEEN DELETED
      return false;
    }
  }
}
