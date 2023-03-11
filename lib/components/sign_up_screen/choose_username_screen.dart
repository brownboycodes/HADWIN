import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadwin/components/main_app_screen/tabbed_layout_component.dart';
import 'package:hadwin/database/login_info_storage.dart';
import 'package:hadwin/database/user_data_storage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hadwin/hadwin_components.dart';

class ChooseUsername extends StatefulWidget {
  final String userAuthKey;
  final Map<String, dynamic> userData;
  const ChooseUsername(
      {Key? key, required this.userAuthKey, required this.userData})
      : super(key: key);

  @override
  _ChooseUsernameState createState() => _ChooseUsernameState();
}

class _ChooseUsernameState extends State<ChooseUsername> {
  LoginInfoStorage loginInfoStorage = LoginInfoStorage();
  UserDataStorage userDataStorage = UserDataStorage();
  late IO.Socket socket;
  late TextEditingController usernameField;
  late bool usernameStatus = false;
  // late String profilePicUrl = '';
  bool _showErrorMessage = false;
  String _message = "your account has been created\nchoose a username";

  void connectAndListen() {
    socket = IO.io(
        '${ApiConstants.baseUrl}/hadwin/v3',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    /*
    socket.onConnect((_) {
      print('connect');
    });
*/
    socket.on('username status', (data) {
      setState(() {
        usernameStatus = data;
        
        // usernameStatus = data[0];
        // profilePicUrl = data[1];
      });
    });

    socket.on('error', (data) {
      socket.disconnect();
      showErrorAlert(context, {'error': data});
    });

    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  void initState() {
    super.initState();
    connectAndListen();

    usernameField = TextEditingController();
  }

  @override
  void dispose() {
    socket.dispose();
    usernameField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 64,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade100,
                 
                  radius: 64,
                  child: ClipOval(
                child: Image.network(
                  "${ApiConstants.baseUrl}/dist/images/hadwin_images/hadwin_users/${widget.userData['gender'].toLowerCase()}/${widget.userData['avatar']}",
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              )
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Container(
              height: 48,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                _showErrorMessage ? 'the username is not available' : _message,
                style: TextStyle(
                    color:
                        _showErrorMessage ? Colors.red : Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 260,
              child: TextField(
                controller: usernameField,
                onChanged: ((value) {
                  socket.emit('username request', [value, widget.userAuthKey]);
                  setState(() {
                    if (_showErrorMessage == true) {
                      _showErrorMessage = false;
                    }
                  });
                }),
                decoration: InputDecoration(
                  suffixIcon: usernameField.text.isEmpty
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                            color: usernameStatus == true
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                          child: Icon(
                            usernameStatus == true
                                ? FluentIcons.checkmark_48_regular
                                : FluentIcons.prohibited_48_regular,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "username",
                  hintStyle: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => trySettingUsername(),
                style: TextStyle(fontSize: 16, color: Color(0xFF929BAB)),
              ),
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.0, color: Color(0xFFF5F7FA)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(-4, -4),
                        color: Colors.white38),
                    BoxShadow(
                        blurRadius: 6.18,
                        spreadRadius: 0.618,
                        offset: Offset(4, 4),
                        color: Colors.blueGrey.shade100)
                  ]),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              width: 270,
              height: 64,
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blueGrey.shade100,
                      offset: Offset(0, 4),
                      blurRadius: 5.0)
                ],
                gradient: RadialGradient(
                    colors: [Color(0xff0070BA), Color(0xff1546A0)],
                    radius: 8.4,
                    center: Alignment(-0.24, -0.36)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                  onPressed: trySettingUsername,
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  )),
            ),
          ],
        ),
        padding: EdgeInsets.all(45),
      ),
    );
  }

  void trySettingUsername() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (usernameField.text.isNotEmpty && usernameStatus == true) {
     
      socket.disconnect();
      Map<String, dynamic> data = {
        ...widget.userData,
        'username': usernameField.text,
        // 'avatar': profilePicUrl
      };
      final status = await Future.wait([
        _saveLoggedInUserData(widget.userAuthKey, data),
        CardsStorage().initializeAvailableCards(widget.userAuthKey),
        SuccessfulTransactionsStorage().initializeSuccessfulTransactions()
      ]);

      if (status[0] == true && status[1] == true && status[2] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
                content: Text("Successfully created account"),
                backgroundColor: Colors.green))
            .closed
            .then((value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => TabbedLayoutComponent(
                          userData: data,
                        )),
                (route) => false));
      }
    } else {
      setState(() {
        _showErrorMessage = true;
      });
    }
  }

  Future<bool> _saveLoggedInUserData(
      String loggedInUserAuthKey, Map<String, dynamic> user) async {
    try {
      Provider.of<UserLoginStateProvider>(context, listen: false)
          .setAuthKeyValue(loggedInUserAuthKey);

      final userIsSaved = await Future.wait([
        userDataStorage.saveUserData(user),
        loginInfoStorage.setPersistentLoginData(
            user['id'].toString(), loggedInUserAuthKey)
      ]);
      Provider.of<UserLoginStateProvider>(context, listen: false)
          .initializeBankBalance(user);
      //* user data saved

      if (userIsSaved[0] && userIsSaved[1]) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
