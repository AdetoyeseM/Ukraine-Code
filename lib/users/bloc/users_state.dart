part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersLoading extends UsersState {}

class UsersError extends UsersState {}

class UsersData extends UsersState {
  final int userCount;
  final List<UserModel> items;

  UsersData(this.items, {this.userCount});
}
