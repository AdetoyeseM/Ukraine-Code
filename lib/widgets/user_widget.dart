import 'package:flutter/material.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/screens/profile/profile_screen.dart';

class UserWidget extends StatelessWidget {
  final UserModel model;
  final VoidCallback onPress;

  const UserWidget({Key key, this.model, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        if (onPress != null) onPress();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: model.id)));
      },
      leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: model.avatarUrl != null
                      ? NetworkImage(model.avatarUrl)
                      : const AssetImage('assets/Images/empty.png')))),
      title: Text(model.username),
    );
  }
}
