part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class ChangePasswordSave extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordSave(this.currentPassword, this.newPassword);
}