import 'package:flutter/material.dart';
import 'package:flutter_app1234/Animation/FadeAnimation.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/Validation.dart';
import 'package:flutter_app1234/screens/bottomtab/HomeTabs.dart';
import 'package:flutter_app1234/screens/intro_screen.dart';
import 'package:flutter_app1234/services/auth.dart';
import 'package:flutter_app1234/shared/loading.dart';
import 'package:flutter_app1234/utilities/validators.dart';

import '../reset.dart';
import '../sign_up.dart';

void main() {
  //Runs the app
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String error = '';

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: loading
          ? Loading()
          : Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 250,
                              width: 250,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/Images/OriginalLogoBRAINLOGO.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Container(
                              child: Text('Login to Mutango',
                                  style: TextStyle(
                                      height: -1,
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold)),
                              margin: const EdgeInsets.only(
                                bottom: 35,
                                right: 220,
                              )),
                          FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.transparent,
                              ),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ),
                                  child: TextFormField(
                                    validator: (value) =>
                                        Validation.isValidEmail(value)
                                            ? null
                                            : 'Enter valid email',
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username or Email",
                                      hintStyle: TextStyle(
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  //Password Line
                                  padding: EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ),

                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (val) => val.isEmpty
                                        ? 'Password is required'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: AppColors.gray)),
                                  ),
                                ),
                                //For forgot password AND sign U
                              ]),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 15, left: 13),
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                child: Text(
                                  'Forgot Password?',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.blue[300], fontSize: 13),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Reset()));
                                },
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 80),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(color: AppColors.gray),
                                ),
                                GestureDetector(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.blue[300],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            margin: EdgeInsets.only(top: 20),
                            child: Stack(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: null,
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'Play as Guest',
                                        style: TextStyle(
                                            color: Colors.blue[400],
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () async {
                                    print(email);
                                    print(password);
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      final result = await _auth
                                          .signInWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() => error =
                                            'Please supply a valid email');
                                        loading = false;
                                      } else {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IntroScreen()),
                                          (route) => false,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          color: Colors.orange[400])),
                                ),
                              )
                            ]),
                          ),
                          Text(error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0)),
                        ]),
                  ),
                ),
              )),
    );
  }
}
