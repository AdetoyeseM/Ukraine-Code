import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/Animation/SlideRightRoute.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/screens/settings/account/settings_account_screen.dart';
import 'package:flutter_app1234/screens/user_privacy_setting/notification_preference_screen.dart';
import 'package:flutter_app1234/screens/user_privacy_setting/manage_my_account_screen.dart';
import 'package:flutter_app1234/screens/user_privacy_setting/privacy_screen.dart';

class PrivancySettingScreen extends StatefulWidget {
  @override
  _PrivancySettingScreen createState() => _PrivancySettingScreen();
}

class _PrivancySettingScreen extends State<PrivancySettingScreen> {
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
          'Privacy and Settings ',
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
              margin: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        //Navigator.push(context, SlideRightRoute(page: PrivacyScreen()));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PrivacyScreen()));
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Privacy",
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: AppFont.roboto)),
                                Icon(
                                  Icons.navigate_next,
                                  color: AppColors.gray_icon_back,
                                )
                              ]))),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                NotificationPreferenceScreen()));
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Notification Preference",
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: AppFont.roboto)),
                                Icon(Icons.navigate_next,
                                    color: AppColors.gray_icon_back)
                              ]))),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SettingsAccountScreen()));
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 60),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Manage my account",
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: AppFont.roboto)),
                                Icon(Icons.navigate_next,
                                    color: AppColors.gray_icon_back)
                              ]))),
                  Divider(),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("ABOUT",
                                style: TextStyle(
                                    color: AppColors.text_light_gray,
                                    fontSize: 16,
                                    fontFamily: AppFont.roboto)),
                          ])),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Terms of Use",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            Icon(
                              Icons.navigate_next,
                              color: AppColors.gray_icon_back,
                            )
                          ])),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Privacy Policy",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            Icon(Icons.navigate_next,
                                color: AppColors.gray_icon_back)
                          ])),
                ],
              ))),
    );
  }
}
