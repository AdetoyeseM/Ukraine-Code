import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';

class Reset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // everything was wrapped in a column because it makes everything easier to align
          // and the SafeArea widget will only take one child
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.orange[400],
                          size: 30,
                        )),
                  ),
                  SizedBox(
                    width: 80,
                    //change the width to put more space between the arrow and text,
                  ),
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 18),
                    child: Text('Reset your password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0)),
                    margin: const EdgeInsets.only(top: 50, bottom: 15)),

                //box starts here
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text('We\'ll help you get your account back. ',
                      style: TextStyle(color: AppColors.gray)),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.gray,
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username or Email Address",
                      hintStyle: TextStyle(color: AppColors.gray),
                    ),
                  ),
                ),
                
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 35),
                  child: InkWell(
                    
                    onTap: () {},
                    child: Container(
                      width: 400,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.orange[400],
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          'Reset',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
