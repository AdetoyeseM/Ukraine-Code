part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {}

class HomeData extends HomeState {
  final List<PostModel> items;
  final List<UserModel> users;
  final String errorMessage;
  final String currentUserId;

  HomeData({this.currentUserId, this.items, this.users = const [], this.errorMessage});
}
