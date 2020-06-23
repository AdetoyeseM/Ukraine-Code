part of 'settings_account_bloc.dart';

@immutable
abstract class SettingsAccountState {}

class SettingsAccountLoading extends SettingsAccountState {}

class SettingsAccountError extends SettingsAccountState {}

class SettingsAccountData extends SettingsAccountState {
  final String email;
  final bool logout;
  final SettingsAccountEvent failureEvent;

  SettingsAccountData({this.email, this.logout = false, this.failureEvent});
}
