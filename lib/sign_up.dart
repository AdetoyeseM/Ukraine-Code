import 'package:flutter/material.dart';
import 'package:flutter_app1234/screens/intro_screen.dart';
import 'package:flutter_app1234/services/auth.dart';
import 'package:flutter_app1234/shared/loading.dart';
import 'package:flutter_app1234/utilities/validators.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  //text field state
  String username = '';
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: loading
          ? Loading()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[50],
                elevation: 0.0,
                centerTitle: true,
                title: Image.asset('assets/Images/OriginalLogoBRAINLOGO.png',
                    fit: BoxFit.contain, height: 120),
                leading: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ),
              backgroundColor: Colors.grey[50],
              body: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(bottom: 40)),
                      Text(
                        'Create an Account',
                        style: TextStyle(
                            letterSpacing: 1.5,
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  BackButtonWidget(),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    child: Text(
                      'Enter a username that is 3+ characters long',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(top: 25, right: 57),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.person), onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: TextFormField(
                                  validator: userNameValidator,
                                  onChanged: (value) => username = value,
                                  decoration:
                                      InputDecoration(hintText: 'Username'),
                                )))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      'Enter a password that is 8+ characters long',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(top: 20, right: 57),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.lock), onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: TextFormField(
                                  validator: (val) => val.length < 8
                                      ? 'Password is required'
                                      : null,
                                  onChanged: (val) => password = val,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(hintText: 'Password'),
                                )))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.mail), onPressed: null),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 20, left: 10),
                                child: TextFormField(
                                  validator: (val) =>
                                      val.isEmpty ? 'Email is required' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                  decoration:
                                      InputDecoration(hintText: 'Email'),
                                )))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 30)),
                        RichText(
                            text: TextSpan(
                                text: 'By pressing sign up, you accept the ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                children: [
                              TextSpan(
                                  text: 'Terms & Condition',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold))
                            ]))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 60,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);

                              final success =
                                  await _auth.registerWithEmailAndPassword(
                                      username, email, password);
                              if (success) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            IntroScreen()),
                                    (r) => true);
                              } else {
                                setState(() =>
                                    error = 'please supply a valid email');
                                loading = false;
                              }
                            }
                          },
                          color: Color(0xFFFF9800),
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
