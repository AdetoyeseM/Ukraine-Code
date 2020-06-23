import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/reposetories/image_reposetory.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final AppBloc appBloc;
  final UserReposetory userReposetory;
  final ImageReposetory imageReposetory;

  UserModel user;
  File image;

  ProfileEditBloc(this.appBloc, this.userReposetory, this.imageReposetory);

  @override
  ProfileEditState get initialState {
    user = appBloc.state.user;
    return ProfileEditData(user: user);
  }

  @override
  Stream<ProfileEditState> mapEventToState(
    ProfileEditEvent event,
  ) async* {
    if (event is ProfileEditInit) yield* _init();
    if (event is ProfileEditPickImage) yield* _pickImage();
    if (event is ProfileEditSave) yield* _save(event);
  }

  Stream<ProfileEditState> _init() async* {}

  Stream<ProfileEditState> _pickImage() async* {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    this.image = image;
    yield ProfileEditData(user: user, image: image);
  }

  Stream<ProfileEditState> _save(ProfileEditSave event) async* {
    yield ProfileEditLoading(user: user, image: image);
    user.username = event.name;
    user.website = event.wibsite;
    user.birthday = event.birthday;
    try {
      if (image != null) {
        user.avatarUrl = await imageReposetory.uploadUserAvatar(user.id, image);
      }
      await userReposetory.saveUser(user);
      appBloc.add(AppUpdateUser(user));
      yield ProfileEditDone(user: user, image: image);
    } catch (ex) {
      yield ProfileEditError(user: user, image: image);
    }
  }
}
