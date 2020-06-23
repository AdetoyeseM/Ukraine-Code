part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {}

class ProfileData extends ProfileState {
  final UserModel user;
  final bool isCurrentUser;
  final bool following;
  final bool followed;
  final int followers;

  ProfileData(
      {this.user,
      this.isCurrentUser,
      this.following = false,
      this.followed,
      this.followers});
}
