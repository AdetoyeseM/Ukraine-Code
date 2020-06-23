import 'package:flutter/material.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/screens/bottomtab/HomeTabs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './authenticate.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      bloc: BlocProvider.of<AppBloc>(context)..add(AppInit()),
      listener: (context, state) {
        if (state.user == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Authenticate()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeTabs()),
              (route) => false);
        }
      },
      child: Scaffold(),
    );
  }
}
