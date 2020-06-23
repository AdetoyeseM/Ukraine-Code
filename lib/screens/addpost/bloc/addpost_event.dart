part of 'addpost_bloc.dart';

@immutable
abstract class AddpostEvent {}

class AddPostAddPhoto extends AddpostEvent {
  final List<File> photos;

  AddPostAddPhoto(this.photos);
}

class AddPostRemovePhoto extends AddpostEvent {
  final File file;

  AddPostRemovePhoto({this.file});
}

class AddPostCreate extends AddpostEvent {
  final PostModel post;

  AddPostCreate(this.post);
}
