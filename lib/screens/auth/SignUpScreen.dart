import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/helper/SharedPrefrenceHelper.dart';

class SignUpScreen extends StatefulWidget {
  final Function toggleView;

  const SignUpScreen({Key key, this.toggleView}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final FireStoreMethods fireStoreMethods = new FireStoreMethods();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  bool isLoading = false;
  bool secureText = true;

  signUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (await fireStoreMethods
          .checkIfUsernameTaken(usernameEditingController.text)) {
        setState(() {
          isLoading = false;
        });
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('User Already exist')));
      } else if (await fireStoreMethods
          .checkIfEmailTaken(emailEditingController.text)) {
        setState(() {
          isLoading = false;
        });
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Email Already exist')));
      } else {
        await _authService
            .signUpWithEmailAndPassword(
                emailEditingController.text, passwordEditingController.text)
            .then((result) {
          if (result != null) {
            Map<String, String> userDataMap = {
              "fullName": nameEditingController.text,
              "userName": usernameEditingController.text,
              "userEmail": emailEditingController.text,
              "photoUrl": ""
            };
            fireStoreMethods.addUserInfo(
                FirebaseAuth.instance.currentUser.uid, userDataMap);

            SharedPrefrencersHelper.saveUserLoggedInSharedPreference(true);
            SharedPrefrencersHelper.saveUserFullNameSharedPreference(
                nameEditingController.text);
            SharedPrefrencersHelper.saveUserNameSharedPreference(
                usernameEditingController.text);
            SharedPrefrencersHelper.saveUserEmailSharedPreference(
                emailEditingController.text);
            isLoading = false;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatScreen()));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Sign Up')),
        body: isLoading
            ? Container(
                child: Center(child: Loading()),
              )
            : _body(size));
  }

  _body(var size) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildPageHeading(),
            SizedBox(height: size.height * 0.05),
            _buildTextFields(),
            SizedBox(height: size.height * 0.03),
            _buildSignUpButton(),
            SizedBox(height: size.height * 0.03),
            _buildSignUpText()
          ],
        ),
      ),
    );
  }

  _buildPageHeading() {
    return Text(
      "Sign Up",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: CustomTextField(
                    containerChild: Icon(
                      Icons.person,
                      color: Colors.black38,
                    ),
                    height: 70,
                    hint: "Full Name",
                    controller: nameEditingController,
                    obscureText: false,
                    validator: (val) {
                      return val.isEmpty || val.length < 3
                          ? "Enter Username 3+ characters"
                          : null;
                    },
                    onTap: () {
                      return;
                    },
                    child: SizedBox(),
                  ),
                ),
                SizedBox(width: 5.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: CustomTextField(
                    containerChild: Icon(
                      Icons.person,
                      color: Colors.black38,
                    ),
                    height: 70,
                    hint: "userName",
                    controller: usernameEditingController,
                    obscureText: false,
                    validator: (val) {
                      return val.isEmpty || val.length < 3
                          ? "Enter Username 3+ characters"
                          : null;
                    },
                    onTap: () {
                      return;
                    },
                    child: SizedBox(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            CustomTextField(
              containerChild: Icon(
                Icons.email,
                color: Colors.black38,
              ),
              height: 70,
              hint: "Email",
              controller: emailEditingController,
              obscureText: false,
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)
                    ? null
                    : "Enter correct email";
              },
              onTap: () {
                return;
              },
              child: SizedBox(),
            ),
            SizedBox(height: 5.0),
            CustomTextField(
              containerChild: Icon(
                Icons.lock,
                color: Colors.black38,
              ),
              height: 70,
              hint: "Password",
              controller: passwordEditingController,
              validator: (val) {
                return val.length < 6 ? "Enter Password 6+ characters" : null;
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
              obscureText: secureText,
            ),
          ],
        ),
      ),
    );
  }

  _buildSignUpButton() {
    return CustomButton(
      height: 50,
      width: 170,
      color: primaryColor,
      onPressed: () {
        signUp();
      },
      child: Text(
        "Sign up",
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
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Text(
        "Sign In here",
        style: TextStyle(color: Colors.blue, fontSize: 20),
      ),
    );
  }
}
