import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserReposetory userReposetory;
  final AppBloc appBloc;

  UserModel user;
  bool followed = false;

  ProfileBloc(this.userReposetory, this.appBloc);

  UserModel get currentUser => appBloc.state.user;

  @override
  ProfileState get initialState => ProfileLoading();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileInit) yield* _init(event);
    if (event is ProfileFollow) yield* _follow();
    if (event is ProfileUnfollow) yield* _unfollow();
  }

  Stream<ProfileState> _init(ProfileInit event) async* {
    yield ProfileLoading();
    final cUser = currentUser;
    try {
      user = await userReposetory.getUserById(event.userId);
      if (user.id != cUser.id) {
        followed = await userReposetory.isFollow(cUser.id, user.id);
      } else {
        appBloc.add(AppUpdateUser(user));
      }
      yield ProfileData(
          user: user, isCurrentUser: user.id == cUser.id, followed: followed);
    } catch (ex) {
      yield ProfileError();
    }
  }

  Stream<ProfileState> _follow() async* {
    final cUser = currentUser;
    yield ProfileData(
        user: user,
        isCurrentUser: user.id == cUser.id,
        following: true,
        followed: followed);
    try {
      if (await userReposetory.subscribe(cUser, user.id)) {
        appBloc.add(AppUpdateUser(cUser));
        user.followers++;
        followed = true;
      }
    } catch (ex) {}
    yield ProfileData(
        user: user, isCurrentUser: user.id == cUser.id, followed: followed);
  }

  Stream<ProfileState> _unfollow() async* {
    final cUser = currentUser;
    yield ProfileData(
        user: user,
        isCurrentUser: user.id == cUser.id,
        following: true,
        followed: followed);
    try {
      if (await userReposetory.unsubscribe(cUser, user.id)) {
        appBloc.add(AppUpdateUser(cUser));
        user.followers--;
        followed = false;
      }
    } catch (ex) {}
    yield ProfileData(
        user: user, isCurrentUser: user.id == cUser.id, followed: followed);
  }
}
