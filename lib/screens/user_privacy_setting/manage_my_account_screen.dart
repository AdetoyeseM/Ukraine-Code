import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/services/auth.dart';
import 'package:flutter_app1234/screens/authenticate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountScreen createState() => _ManageAccountScreen();
}

class _ManageAccountScreen extends State<ManageAccountScreen> {
  TextEditingController email_controller;
  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AppBloc>(context).state.user;

    email_controller = new TextEditingController(text: user.id);
  }

  String email = '';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar(),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Account information",
                                style: TextStyle(
                                    color: AppColors.text_light_gray,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                          ])),
                  emailWiget(),
                  verifyWiget(),
                  Divider(),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Password",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                          ])),
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Change password",
                                style: TextStyle(
                                    color: AppColors.text_light_gray,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            Icon(
                              Icons.navigate_next,
                              color: AppColors.gray_icon_back,
                            )
                          ])),
                  Container(
                      margin: EdgeInsets.only(top: 300),
                      child: GestureDetector(
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Authenticate()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Logout",
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.red,
                                      fontSize: 15,
                                      fontFamily: AppFont.roboto)),
                            ]),
                      )),
                ],
              ))),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 2,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'Manage my account',
        style: TextStyle(color: Colors.black, fontFamily: AppFont.medium),
      ),
      leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),

      // action button
    );
  }

  Widget emailWiget() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Email",
                  style: TextStyle(
                      color: AppColors.text_light_gray,
                      fontSize: 14,
                      fontFamily: AppFont.roboto)),
              new Flexible(
                  child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: AppFont.roboto),
                      maxLines: 1,
                      controller: email_controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter email",
                        hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppFont.roboto),
                        fillColor: Colors.transparent,
                        filled: true,
                      )))
            ]));
  }

  Widget verifyWiget() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Change/Verify Email",
                  style: TextStyle(
                      color: AppColors.text_light_gray,
                      fontSize: 14,
                      fontFamily: AppFont.roboto)),
              Icon(Icons.navigate_next, color: AppColors.gray_icon_back)
            ]));
  }
}
