part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchData extends SearchState {
  final List<UserModel> items;

  SearchData(this.items);
}

class SearchError extends SearchState {
  final SearchEvent lastEvent;

  SearchError(this.lastEvent);
}
