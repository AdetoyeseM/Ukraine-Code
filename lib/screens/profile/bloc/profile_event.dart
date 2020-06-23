part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileInit extends ProfileEvent {
  final String userId;

  ProfileInit(this.userId);
}

class ProfileFollow extends ProfileEvent {}

class ProfileUnfollow extends ProfileEvent {}
