import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/reposetories/image_reposetory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/screens/intro_screen.dart';

import 'reposetories/user_reposetory.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) =>
          AppBloc(FirebaseUserReposetory(), FirebaseImageReposetory()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IntroScreen(),
      ),
    );
  }
}

class AppBloc extends Bloc<AppEvent, AppState> {
  final UserReposetory userReposetory;
  final ImageReposetory imageReposetory;

  AppBloc(this.userReposetory, this.imageReposetory);

  @override
  AppState get initialState => AppState();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppInit) yield* _init();
    if (event is AppUpdateUser) yield* _updateUser(event);
  }

  Stream<AppState> _init() async* {
    try {
      final fUser = await FirebaseAuth.instance.currentUser();
      if (fUser != null) {
        final model = await userReposetory.getUser(fUser.uid);
        yield AppState(user: model);
      } else {
        yield AppState();
      }
    } catch (ex) {
      yield AppState();
    }
  }

  Stream<AppState> _updateUser(AppUpdateUser event) async* {
    yield AppState(user: event.user);
  }
}

class AppState {
  final UserModel user;

  AppState({this.user});
}

abstract class AppEvent {}

class AppInit extends AppEvent {}

class AppUpdateUser extends AppEvent {
  final UserModel user;

  AppUpdateUser(this.user);
}
