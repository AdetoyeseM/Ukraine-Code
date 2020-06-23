import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_app1234/data/models/user.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserReposetory userReposetory;
  final String currentUserId;

  SearchBloc(this.userReposetory, this.currentUserId);

  @override
  SearchState get initialState => SearchInitial();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchQuery) yield* _query(event);
  }

  Stream<SearchState> _query(SearchQuery event) async* {
    yield SearchLoading();
    try {
      var items = await userReposetory.findUsers(event.text);
      items = items.where((i) => i.id != currentUserId).toList();
      yield SearchData(items);
    } catch (ex) {
      yield SearchError(event);
    }
  }
}
