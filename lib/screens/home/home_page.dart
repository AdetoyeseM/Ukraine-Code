import 'package:flutter/material.dart';
import 'package:flutter_app1234/data/models/post.dart';
import 'package:flutter_app1234/screens/home/bloc/home_bloc.dart';
import 'package:flutter_app1234/widgets/error_container.dart';
import 'package:flutter_app1234/widgets/post_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeData && state.errorMessage != null) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading)
            return Center(child: CircularProgressIndicator());
          if (state is HomeData)
            return RefreshIndicator(onRefresh: () {
              BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
              return Future.delayed(Duration(seconds: 1));
            }, child: () {
              if (state.items.length == 0) {
                return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Empty'),
                        ],
                      )
                    ]);
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (context, index) {
                      final post = state.items[index];
                      return PostWidget(
                        itemIndex: index,
                        showMenu: post.userId == state.currentUserId,
                        user: state.users.firstWhere(
                          (i) => i.id == post.userId,
                          orElse: () {
                            return null;
                          },
                        ),
                        model: post,
                        onMenuClick: () => _showPostModalMenu(context, post),
                      );
                    },
                    itemCount: state.items.length);
              }
            }());
          else
            return ErrorContainer(
                onRepeat: () =>
                    BlocProvider.of<HomeBloc>(context).add(HomeLoad()));
        },
      ),
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
                        BlocProvider.of<HomeBloc>(context)
                            .add(HomeHidePost(post));
                      }),
                  ListTile(
                      title: Text(
                        'Delete Post',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        BlocProvider.of<HomeBloc>(context)
                            .add(HomeDeletePost(post));
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
