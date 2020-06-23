import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/screens/authenticate.dart';
import 'package:flutter_app1234/screens/settings/account/bloc/settings_account_bloc.dart';
import 'package:flutter_app1234/screens/settings/change_password/change_password_screen.dart';
import 'package:flutter_app1234/services/auth.dart';
import 'package:flutter_app1234/widgets/error_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsAccountScreen extends StatelessWidget {
  const SettingsAccountScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsAccountBloc>(
      create: (context) =>
          SettingsAccountBloc(AuthService())..add(SettingsAccountInit()),
      child: _SettingsAccountWidget(),
    );
  }
}

class _SettingsAccountWidget extends StatefulWidget {
  _SettingsAccountWidget({Key key}) : super(key: key);

  @override
  _SettingsAccountWidgetState createState() => _SettingsAccountWidgetState();
}

class _SettingsAccountWidgetState extends State<_SettingsAccountWidget> {
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsAccountBloc, SettingsAccountState>(
      listener: (context, state) {
        if (state is SettingsAccountData) {
          controller.text = state.email;
          if (state.logout) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Authenticate()),
              (Route<dynamic> route) => false,
            );
          }
          if (state.failureEvent != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Error'),
                action: SnackBarAction(
                    label: 'Retry',
                    onPressed: () =>
                        BlocProvider.of<SettingsAccountBloc>(context)
                            .add(state.failureEvent))));
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: appBar(),
        body: BlocBuilder<SettingsAccountBloc, SettingsAccountState>(
            builder: (context, state) {
          if (state is SettingsAccountData)
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(top: 5, left: 15, right: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Account information",
                                      style: TextStyle(
                                          color: AppColors.text_light_gray,
                                          fontSize: 14,
                                          fontFamily: AppFont.roboto)),
                                ])),
                        emailWiget(),
                        verifyWiget(),
                        Divider(height: 1),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangePasswordScreen())),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text("Change password",
                                        style: TextStyle(
                                            fontFamily: AppFont.roboto))),
                                Icon(
                                  Icons.navigate_next,
                                  color: AppColors.gray_icon_back,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 300),
                            child: GestureDetector(
                              onTap: () =>
                                  BlocProvider.of<SettingsAccountBloc>(context)
                                      .add(SettingsAccountLogout()),
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
                    )));
          if (state is SettingsAccountError)
            return ErrorContainer(
                onRepeat: () =>
                    BlocProvider.of(context).add(SettingsAccountInit()));

          return Center(child: CircularProgressIndicator());
        }),
      ),
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
                      controller: controller,
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
