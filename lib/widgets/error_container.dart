import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final VoidCallback onRepeat;

  const ErrorContainer({Key key, this.onRepeat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Error'),
          RaisedButton(
              color: Colors.green,
              child: Text('Retry'),
              onPressed: onRepeat)
        ],
      ),
    );
  }
}
