import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/data/models/post.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/reposetories/post_reposetory.dart';
import 'package:meta/meta.dart';

part 'user_post_event.dart';
part 'user_post_state.dart';

class UserPostBloc extends Bloc<UserPostEvent, UserPostState> {
  final PostReposetory postReposetory;
  final UserModel user;
  final bool isCurrentUser;
  final List<PostModel> items = [];

  UserPostBloc(this.postReposetory, this.user, this.isCurrentUser);

  @override
  UserPostState get initialState => UserPostLoading();

  @override
  Stream<UserPostState> mapEventToState(
    UserPostEvent event,
  ) async* {
    if (event is UserPostLoad) yield* _load();
    if (event is UserPostDeletePost) yield* _deletePost(event);
    if (event is UserPostHidePost) yield* _hidePost(event);
  }

  Stream<UserPostState> _load() async* {
    if (!(state is UserPostData)) yield UserPostLoading();
    try {
      final result = await postReposetory.getOlderPosts(30,
          lastDocumentId: items.length > 0 ? items.last.id : null,
          userId: user.id,
          showInvisiblePosts: isCurrentUser);
      items.addAll(result);
      yield UserPostData(
          user: user, items: items, isCurrentUser: isCurrentUser);
    } catch (ex) {
      yield UserPostError();
    }
  }

  Stream<UserPostState> _deletePost(UserPostDeletePost event) async* {
    try {
      await postReposetory.delete(event.post);
      items.remove(event.post);
      yield UserPostData(
          user: user, items: items, isCurrentUser: isCurrentUser);
    } catch (ex) {
      yield UserPostData(
          user: user, items: items, isCurrentUser: isCurrentUser);
    }
  }

  Stream<UserPostState> _hidePost(UserPostHidePost event) async* {
    try {
      event.post.visibility = !event.post.visibility;
      await postReposetory.save(event.post);
      yield UserPostData(
          user: user, items: items, isCurrentUser: isCurrentUser);
    } catch (ex) {
      yield UserPostData(
          user: user, items: items, isCurrentUser: isCurrentUser);
    }
  }
}
