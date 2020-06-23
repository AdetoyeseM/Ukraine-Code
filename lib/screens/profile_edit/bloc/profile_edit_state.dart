part of 'profile_edit_bloc.dart';

@immutable
abstract class ProfileEditState {
  final UserModel user;
  final File image;

  ProfileEditState({this.user, this.image});
}

class ProfileEditData extends ProfileEditState {
  ProfileEditData({UserModel user, File image})
      : super(user: user, image: image);
}

class ProfileEditDone extends ProfileEditState {
  ProfileEditDone({UserModel user, File image})
      : super(user: user, image: image);
}

class ProfileEditError extends ProfileEditState {
  ProfileEditError({UserModel user, File image})
      : super(user: user, image: image);
}

class ProfileEditLoading extends ProfileEditState {
  ProfileEditLoading({UserModel user, File image})
      : super(user: user, image: image);
}
