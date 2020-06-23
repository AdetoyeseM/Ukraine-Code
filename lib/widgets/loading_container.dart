import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final bool loading;
  final Widget child;

  const LoadingContainer({Key key, this.loading = false, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (loading)
          Positioned.fill(
              child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(child: CircularProgressIndicator()),
          ))
      ],
    );
  }
}
