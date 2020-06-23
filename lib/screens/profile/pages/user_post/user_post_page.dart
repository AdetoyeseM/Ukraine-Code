import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/data/models/post.dart';
import 'package:flutter_app1234/widgets/post_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_post_bloc.dart';

class UserPostPage extends StatelessWidget {
  const UserPostPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPostBloc, UserPostState>(
      builder: (context, state) {
        if (state is UserPostData && state.items.length > 0) {
          return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: state.items.length,
              itemBuilder: (context, index) => PostWidget(
                    itemIndex: index,
                    model: state.items[index],
                    showMenu: state.isCurrentUser,
                    user: state.user,
                    navigateToUser: false,
                    onMenuClick: () =>
                        _showPostModalMenu(context, state.items[index]),
                  ));
        }
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              () {
                if (state is UserPostError)
                  return Column(
                    children: [
                      Text('Error'),
                      RaisedButton(
                          child: Text('Retry'),
                          onPressed: () =>
                              BlocProvider.of<UserPostBloc>(context)
                                  .add(UserPostLoad()))
                    ],
                  );
                if (state is UserPostLoading)
                  return CircularProgressIndicator();
                return Text('Empty');
              }()
            ],
          ),
        );
      },
    );
  }

  void _showPostModalMenu(BuildContext context, PostModel post) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Material(
              color: Colors.white,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      title: Text(
                        post.visibility ? 'Hide Post' : 'Show Post',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        BlocProvider.of<UserPostBloc>(context)
                            .add(UserPostHidePost(post));
                      }),
                  ListTile(
                      title: Text(
                        'Delete Post',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        BlocProvider.of<UserPostBloc>(context)
                            .add(UserPostDeletePost(post));
                      }),
                  ListTile(
                      title: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () => Navigator.pop(context))
                ],
              ),
            ),
          );
        });
  }
}
