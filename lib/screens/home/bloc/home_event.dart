part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeLoad extends HomeEvent {}

class HomeRefresh extends HomeEvent {
  final bool cleanCurrent;

  HomeRefresh({this.cleanCurrent = false});
}

class HomeDeletePost extends HomeEvent {
  final PostModel post;

  HomeDeletePost(this.post);
}

class HomeHidePost extends HomeEvent {
  final PostModel post;

  HomeHidePost(this.post);
}
