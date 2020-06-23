import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/data/models/post.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/reposetories/post_reposetory.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostReposetory postReposetory;
  final UserReposetory userReposetory;
  final UserModel currentUser;
  final List<PostModel> items = [];
  final List<UserModel> users = [];

  HomeBloc(this.postReposetory, this.userReposetory, this.currentUser);

  @override
  HomeState get initialState => HomeLoading();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeRefresh) yield* _refresh();
    if (event is HomeLoad) yield* _load();
    if (event is HomeDeletePost) yield* _deletePost(event);
    if (event is HomeHidePost) yield* _hidePost(event);
  }

  Stream<HomeState> _refresh() async* {
    items.clear();
    users.clear();
    yield HomeLoading();
    yield* _load();
  }

  Stream<HomeState> _load() async* {
    if (!(state is HomeData)) yield HomeLoading();
    try {
      final result = await postReposetory.getOlderPosts(30,
          lastDocumentId: items.length > 0 ? items.last.id : null);
      if (result.length > 0) {
        final userIds = result.map((e) => e.userId).toList();
        users.addAll(await _getUsers(userIds));
        items.addAll(result);
      }
      yield HomeData(currentUserId: currentUser.id, items: items, users: users);
    } catch (ex) {
      yield HomeError();
    }
  }

  Stream<HomeState> _deletePost(HomeDeletePost event) async* {
    try {
      await postReposetory.delete(event.post);
      items.remove(event.post);
      yield HomeData(currentUserId: currentUser.id, items: items, users: users);
    } catch (ex) {
      yield HomeData(
          currentUserId: currentUser.id,
          items: items,
          users: users,
          errorMessage: 'Error');
    }
  }

  Stream<HomeState> _hidePost(HomeHidePost event) async* {
    try {
      event.post.visibility = !event.post.visibility;
      await postReposetory.save(event.post);
      yield HomeData(currentUserId: currentUser.id, items: items, users: users);
    } catch (ex) {
      yield HomeData(
          currentUserId: currentUser.id,
          items: items,
          users: users,
          errorMessage: 'Error');
    }
  }

  Future<List<UserModel>> _getUsers(List<String> userIds) async {
    final ids = List<String>();
    userIds.forEach((i) {
      if (!users.any((user) => user.id == i) && !ids.any((e) => e == i)) {
        ids.add(i);
      }
    });
    final models = await userReposetory.getUsers(ids);
    return models;
  }
}
