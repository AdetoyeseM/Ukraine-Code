part of 'user_post_bloc.dart';

@immutable
abstract class UserPostEvent {}

class UserPostLoad extends UserPostEvent {}

class UserPostDeletePost extends UserPostEvent {
  final PostModel post;

  UserPostDeletePost(this.post);
}

class UserPostHidePost extends UserPostEvent {
  final PostModel post;

  UserPostHidePost(this.post);
}
