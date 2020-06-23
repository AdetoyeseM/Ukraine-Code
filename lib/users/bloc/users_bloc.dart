import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/data/models/follower.dart';
import 'package:flutter_app1234/data/models/subscriber.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserReposetory userReposetory;
  final UserType userType;
  final String userId;

  final List<String> userIds = [];

  int lastIndex;

  UsersBloc(this.userReposetory, this.userType, this.userId);

  @override
  UsersState get initialState => UsersLoading();

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    if (event is UsersLoad) yield* _load();
  }

  Stream<UsersState> _load() async* {
    if (!(state is UsersData)) yield UsersLoading();
    try {
      final users = List<UserModel>();
      if (userIds.length == 0) {
        switch (userType) {
          case UserType.followers:
            final followers = await userReposetory.getFollowers(userId);
            userIds.addAll(followers.map((e) => e.userId).toList());
            break;
          case UserType.subscribers:
            final followers = await userReposetory.getSubscription(userId);
            userIds.addAll(followers.map((e) => e.userId).toList());
            break;
        }
      }
      var size = userIds.length - (lastIndex ?? 0);
      if (size > 30) size = 30;
      if (size > 0) {
        users.addAll(await userReposetory.getUsers(userIds
            .getRange(lastIndex ?? 0, (lastIndex ?? 0) + size)
            .toList()));
      }
      yield UsersData(users, userCount: userIds.length);
    } catch (ex) {
      yield UsersError();
    }
  }
}

enum UserType { followers, subscribers }
