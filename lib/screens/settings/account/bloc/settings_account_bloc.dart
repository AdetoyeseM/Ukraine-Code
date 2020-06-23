import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/services/auth.dart';
import 'package:meta/meta.dart';

part 'settings_account_event.dart';
part 'settings_account_state.dart';

class SettingsAccountBloc
    extends Bloc<SettingsAccountEvent, SettingsAccountState> {
  final AuthService authService;

  String email;

  SettingsAccountBloc(this.authService);

  @override
  SettingsAccountState get initialState => SettingsAccountLoading();

  @override
  Stream<SettingsAccountState> mapEventToState(
    SettingsAccountEvent event,
  ) async* {
    if (event is SettingsAccountInit) yield* _init();
    if (event is SettingsAccountLogout) yield* _logout(event);
  }

  Stream<SettingsAccountState> _init() async* {
    try {
      final user = await authService.currentUser();
      email = user.email;
      yield SettingsAccountData(email: email);
    } catch (ex) {
      yield SettingsAccountError();
    }
  }

  Stream<SettingsAccountState> _logout(SettingsAccountLogout event) async* {
    try {
      await authService.signOut();
      yield SettingsAccountData(email: email, logout: true);
    } catch (ex) {
      yield SettingsAccountData(email: email, failureEvent: event);
    }
  }
}
