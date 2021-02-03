import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/screens/auth/Authentication.dart';
import 'package:flutter_firebase_chat/helper/SharedPrefrenceHelper.dart';
import 'package:flutter_firebase_chat/screens/chat/ChatScreen.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool userIsLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await SharedPrefrencersHelper.getUserLoggedInSharedPreference()
        .then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn == true ? ChatScreen() : Authenticate(),
    );
  }
}
