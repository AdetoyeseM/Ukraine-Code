part of 'user_post_bloc.dart';

@immutable
abstract class UserPostState {}

class UserPostLoading extends UserPostState {}

class UserPostError extends UserPostState {}

class UserPostData extends UserPostState {
  final List<PostModel> items;
  final UserModel user;
  final bool isCurrentUser;

  UserPostData({this.user, this.items, this.isCurrentUser});
}
