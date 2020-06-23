part of 'profile_edit_bloc.dart';

@immutable
abstract class ProfileEditEvent {}

class ProfileEditInit extends ProfileEditEvent {}

class ProfileEditPickImage extends ProfileEditEvent {}

class ProfileEditSave extends ProfileEditEvent {
  final String name, wibsite, birthday;

  ProfileEditSave({this.name, this.wibsite, this.birthday});
}
