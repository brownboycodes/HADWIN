import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class UserDataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _userDataFile async {
    final path = await _localPath;
    return File('$path/hadwin_user_data.json');
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final file = await _userDataFile;

      final contents = await file.readAsString();

      return jsonDecode(contents);
    } catch (e) {
      return {"localDBError": "unable to parse data"};
    }
  }

  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final file = await _userDataFile;
      return file.writeAsString(jsonEncode(userData)).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFile() async {
    try {
      final file = await _userDataFile;

      await file.delete();
      //* THE USER DATA FILE HAS BEEN DELETED
      return true;
    } catch (e) {
    //* THE USER DATA FILE HAS NOT BEEN DELETED
      return false;
    }
  }
}
