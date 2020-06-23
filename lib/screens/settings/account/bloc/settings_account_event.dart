part of 'settings_account_bloc.dart';

@immutable
abstract class SettingsAccountEvent {}

class SettingsAccountInit extends SettingsAccountEvent {}

class SettingsAccountLogout extends SettingsAccountEvent {}