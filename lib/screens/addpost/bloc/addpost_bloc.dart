import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app1234/data/models/post.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/reposetories/image_reposetory.dart';
import 'package:flutter_app1234/reposetories/post_reposetory.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'addpost_event.dart';
part 'addpost_state.dart';

class AddpostBloc extends Bloc<AddpostEvent, AddpostState> {
  final PostReposetory postReposetory;
  final ImageReposetory imageReposetory;
  final List<File> photos = [];

  final UserModel user;

  AddpostBloc(this.postReposetory, this.imageReposetory, this.user);

  @override
  AddpostState get initialState => AddpostInitial();

  @override
  Stream<AddpostState> mapEventToState(AddpostEvent event) async* {
    if (event is AddPostCreate) yield* _create(event);
    if (event is AddPostAddPhoto) yield* _addPhoto(event);
    if (event is AddPostRemovePhoto) yield* _removePhoto(event);
  }

  Stream<AddpostState> _create(AddPostCreate event) async* {
    yield AddpostLoading(photos: photos);
    event.post.userId = user.id;
    event.post.createdAt = Timestamp.now().millisecondsSinceEpoch;
    try {
      final post = event.post;
      final ref = await postReposetory.addPost(post);
      if (photos.length > 0) {
        final imageUrls =
            await imageReposetory.uploadPostImages(ref.documentID, photos);
        await ref.updateData({'photos': imageUrls});
      }
      yield AddpostSaved(photos: photos, post: event.post);
    } catch (ex) {
      yield AddpostError(photos: photos);
    }
  }

  Stream<AddpostState> _addPhoto(AddPostAddPhoto event) async* {
    photos.addAll(event.photos);
    yield AddpostInitial(photos: photos);
  }

  Stream<AddpostState> _removePhoto(AddPostRemovePhoto event) async* {
    photos.remove(event.file);
    yield AddpostInitial(photos: photos);
  }
}
