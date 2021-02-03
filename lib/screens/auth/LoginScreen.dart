import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/helper/SharedPrefrenceHelper.dart';
import 'package:flutter_firebase_chat/screens/auth/SignUpScreen.dart';
import 'package:flutter_firebase_chat/screens/chat/ChatScreen.dart';
import 'package:flutter_firebase_chat/services/AuthService.dart';
import 'package:flutter_firebase_chat/utils/Constants.dart';
import 'package:flutter_firebase_chat/widgets/Loading.dart';
import 'package:flutter_firebase_chat/widgets/custom_button.dart';
import 'package:flutter_firebase_chat/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;

  LoginScreen({Key key, this.toggleView}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  bool isLoading = false;
  bool secureText = true;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await _authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          SharedPrefrencersHelper.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        } else {
          setState(() {
            isLoading = false;
          });
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text('Wrong Email or Password')));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Sign In')),
        body: isLoading
            ? Container(
                child: Center(child: Loading()),
              )
            : _body(context, size));
  }

  _body(BuildContext context, var size) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildPageHeading(),
            SizedBox(height: size.height * 0.05),
            _buildTextFields(),
            SizedBox(height: size.height * 0.03),
            _buildLoginButton(),
            SizedBox(height: size.height * 0.03),
            _buildSignUpText()
          ],
        ),
      ),
    );
  }

  _buildPageHeading() {
    return Text(
      "Sign In",
      style: TextStyle(
          color: Colors.blue, fontSize: 30, fontWeight: FontWeight.w900),
    );
  }

  _buildTextFields() {
    return Align(
      alignment: Alignment.center,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              containerChild: Icon(
                Icons.email,
                color: Colors.black38,
              ),
              height: 70,
              obscureText: false,
              hint: "Email",
              controller: emailEditingController,
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)
                    ? null
                    : 'Please Enter Correct Email';
              },
              onTap: () {
                return;
              },
              child: SizedBox(),
            ),
            SizedBox(
              height: 5.0,
            ),
            CustomTextField(
              containerChild: Icon(
                Icons.lock,
                color: Colors.black38,
              ),
              height: 70,
              obscureText: secureText,
              hint: "Password",
              controller: passwordEditingController,
              validator: (val) {
                return val.length >= 6 ? null : 'Enter Password 6+ characters';
              },
              onTap: () {
                if (secureText == true) {
                  secureText = false;
                } else {
                  secureText = true;
                }
                setState(() {});
              },
              child:
                  Icon(secureText == true ? Icons.remove_red_eye : Icons.clear),
            )
          ],
        ),
      ),
    );
  }

  _buildLoginButton() {
    return CustomButton(
      height: 50,
      width: 170,
      color: primaryColor,
      onPressed: () {
        signIn();
      },
      child: Text(
        "Log in",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildSignUpText() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
      child: Text(
        "Sign up",
        style: TextStyle(color: Colors.blue, fontSize: 20),
      ),
    );
  }
}
