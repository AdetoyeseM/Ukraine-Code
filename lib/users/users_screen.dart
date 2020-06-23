import 'package:flutter/material.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:flutter_app1234/users/bloc/users_bloc.dart';
import 'package:flutter_app1234/widgets/error_container.dart';
import 'package:flutter_app1234/widgets/user_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  final String userId;
  final String title;
  final UserType userType;

  const UsersScreen({Key key, this.userId, this.title, this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersBloc>(
      create: (context) => UsersBloc(FirebaseUserReposetory(), userType, userId)
        ..add(UsersLoad()),
      child: _UsersWidget(title: title),
    );
  }
}

class _UsersWidget extends StatelessWidget {
  final String title;

  const _UsersWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
        return CustomScrollView(slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
                state is UsersData ? "$title (${state.userCount})" : title,
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
          ),
          if (state is UsersData && state.items.length > 0)
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => UserWidget(model: state.items[index]),
                    childCount: state.items.length))
          else
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: () {
                if (state is UsersLoading)
                  return Center(child: CircularProgressIndicator());
                if (state is UsersError)
                  return ErrorContainer(
                      onRepeat: () =>
                          BlocProvider.of<UsersBloc>(context).add(UsersLoad()));
                return Center(child: Text('Empty'));
              }(),
            )
        ]);
      }),
    );
  }
}
