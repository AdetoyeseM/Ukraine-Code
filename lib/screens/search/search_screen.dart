import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:flutter_app1234/screens/search/bloc/search_bloc.dart';
import 'package:flutter_app1234/widgets/error_container.dart';
import 'package:flutter_app1234/widgets/user_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(FirebaseUserReposetory(),
          BlocProvider.of<AppBloc>(context).state.user.id),
      child: _SearchWidget(),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.yellow, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                width: Size.infinite.width,
                padding: EdgeInsets.only(left: 8),
                child: _SearchInput(
                  onQuery: (value) => BlocProvider.of<SearchBloc>(context)
                      .add(SearchQuery(value)),
                )),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchData && state.items.length > 0)
                    return ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) => UserWidget(
                            model: state.items[index],
                            onPress: () => FocusScope.of(context)
                                .requestFocus(FocusNode())));
                  if (state is SearchError)
                    return ErrorContainer(
                        onRepeat: () =>
                            BlocProvider.of(context).add(state.lastEvent));
                  if (state is SearchLoading)
                    return Center(child: CircularProgressIndicator());

                  return Center(child: Text('Empty'));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchInput extends StatefulWidget {
  final QueryCallback onQuery;

  _SearchInput({Key key, this.onQuery}) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  TextEditingController controller;
  Timer timer;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autocorrect: true,
      onChanged: (value) {
        timer?.cancel();
        timer = Timer.periodic(Duration(milliseconds: 500), (t) {
          t.cancel();
          widget.onQuery(value);
        });
      },
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search, color: AppColors.gray),
        suffixIcon: IconButton(
            icon: Icon(Icons.close), onPressed: () => controller.text = ''),
        hintStyle: TextStyle(color: AppColors.gray),
        filled: true,
        border: InputBorder.none,
        fillColor: Colors.transparent,
      ),
    );
  }
}

typedef QueryCallback = void Function(String value);
