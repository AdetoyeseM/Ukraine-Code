import 'package:flutter/material.dart';
import 'package:flutter_app1234/screens/login_screen.dart';
import 'package:flutter_app1234/sign_up.dart';

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double _shortestSide = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: _height / 2,
              width: _width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/Images/OriginalLogoBRAINLOGO.png'))),
            ),
            Container(
                height: _height / 2,
                width: _width,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => null,
                        child: Text(
                          'Login with services!',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: _shortestSide <= 600 ? 15 : 30,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 25), //25
                    ),
                    _buildContainersButtons(
                        context: context,
                        buttonText: 'Sign In',
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        }),
                    SizedBox(
                      height: 5,
                    ),
                    _buildContainersButtons(
                        context: context,
                        buttonText: 'Sign Up',
                        function: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () => null,
                        child: Text(
                          'Play as a guest!',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: _shortestSide <= 600 ? 15 : 30,
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
  }

  Widget _buildContainersButtons(
      {BuildContext context, String buttonText, Function function}) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double _shortestSide = MediaQuery.of(context).size.shortestSide;
    return GestureDetector(
        onTap: () => function(),
        child: Container(
          alignment: Alignment.center,
          height: _height * 0.1,
          width: _width,
          child: Text(
            buttonText,
            style: TextStyle(
                color: Colors.white,
                fontSize: _shortestSide <= 600 ? 25.0 : 30.0),
          ),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }
}
