import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1234/services/auth.dart';
import 'package:meta/meta.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthService authService;

  ChangePasswordBloc(this.authService);

  @override
  ChangePasswordState get initialState => ChangePasswordInitial();

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is ChangePasswordSave) yield* _save(event);
  }

  Stream<ChangePasswordState> _save(ChangePasswordSave event) async* {
    yield ChangePasswordLoading();
    try {
      await authService.changePassword(
          event.currentPassword, event.newPassword);
      yield ChangePasswordSaved();
    } on PlatformException catch (ex) {
      if (ex.code == 'ERROR_WRONG_PASSWORD')
        yield ChangePasswordError('Wrong current password');
    }
  }
}
