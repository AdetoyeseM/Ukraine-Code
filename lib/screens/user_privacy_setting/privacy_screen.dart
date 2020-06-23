import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreen createState() => _PrivacyScreen();
}

class _PrivacyScreen extends State<PrivacyScreen> {
  bool _switchValue = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Privacy',
          style: TextStyle(color: Colors.black, fontFamily: AppFont.medium),
        ),
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),

        // action button
      ),
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
                            Text("ACCOUNT  PRIVACY",
                                style: TextStyle(
                                    color: AppColors.text_light_gray,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                          ])),
                  Container(
                      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Private Account",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            CupertinoSwitch(
                              value: _switchValue,
                              onChanged: (value) {
                                setState(() {
                                  _switchValue = value;
                                });
                              },
                            )
                          ])),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    "Only show your account to people who already follows you and people you approve. This does not affect your current followers",
                                    style: TextStyle(
                                        color: AppColors.text_light_gray,
                                        fontSize: 14,
                                        fontFamily: AppFont.roboto))),
                            Icon(
                              Icons.navigate_next,
                              color: AppColors.gray_icon_back,
                            )
                          ])),
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Block Accounts",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            Icon(Icons.navigate_next,
                                color: AppColors.gray_icon_back)
                          ]))
                ],
              ))),
    );
  }
}
