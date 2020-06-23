import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeScreen extends StatefulWidget {
  @override
  _MeScreen createState() => _MeScreen();
}

class _MeScreen extends State<MeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Profile screen"),
      ),
    );
  }
}
