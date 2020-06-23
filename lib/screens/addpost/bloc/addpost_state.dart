part of 'addpost_bloc.dart';

@immutable
abstract class AddpostState {
  final List<File> photos;

  AddpostState(this.photos);
}

class AddpostInitial extends AddpostState {
  AddpostInitial({List<File> photos = const []}) : super(photos);
}

class AddpostLoading extends AddpostState {
  AddpostLoading({List<File> photos}) : super(photos);
}

class AddpostError extends AddpostState {
  AddpostError({List<File> photos}) : super(photos);
}

class AddpostSaved extends AddpostState {
  final PostModel post;
  AddpostSaved({List<File> photos, this.post}) : super(photos);
}
