import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';

class NotificationPreferenceScreen extends StatefulWidget {
  @override
  _NotificationPreferenceScreen createState() =>
      _NotificationPreferenceScreen();
}

class _NotificationPreferenceScreen
    extends State<NotificationPreferenceScreen> {
  bool _switch_all_notif = true;
  bool _switchcomment_notif = true;
  bool _switch_follow_notif = true;
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
          'Notification Preference',
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
                            Text("Notification Alerts",
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
                            Text("Turn off all Notifications",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            CupertinoSwitch(
                              value: _switch_all_notif,
                              onChanged: (value) {
                                setState(() {
                                  _switch_all_notif = value;
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
                                    "This switch  turns all notifications,Notification for when a user comments and follows you will be turned off",
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
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Comment Notifications",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            CupertinoSwitch(
                              value: _switchcomment_notif,
                              onChanged: (value) {
                                setState(() {
                                  _switchcomment_notif = value;
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
                                    "This switch  turns ONLY comment notification When a user comments on yours post, you will not get a notification",
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
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Follower Notifications",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontFamily: AppFont.roboto)),
                            CupertinoSwitch(
                              value: _switch_follow_notif,
                              onChanged: (value) {
                                setState(() {
                                  _switch_follow_notif = value;
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
                                    "This switch  turns ONLY comment notification When a user follows you,you will not get a notification",
                                    style: TextStyle(
                                        color: AppColors.text_light_gray,
                                        fontSize: 14,
                                        fontFamily: AppFont.roboto))),
                            Icon(
                              Icons.navigate_next,
                              color: AppColors.gray_icon_back,
                            )
                          ])),
                ],
              ))),
    );
  }
}
