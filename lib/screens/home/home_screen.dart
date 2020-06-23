import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/reposetories/post_reposetory.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:flutter_app1234/screens/addpost/addpost_screen.dart';
import 'package:flutter_app1234/screens/bottomtab/recommended_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'home_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
          FirebasePostReposetory(),
          FirebaseUserReposetory(),
          BlocProvider.of<AppBloc>(context).state.user)
        ..add(HomeLoad()),
      child: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Home'),
    Tab(text: 'Recommended'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: AppColors.white),
          backgroundColor: AppColors.yellow,
          onPressed: () async {
            final result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddpostScreen()));
            if (result != null) {
              BlocProvider.of<HomeBloc>(context).add(HomeRefresh(cleanCurrent: true));
            }
          }),
      body: Container(
          child: TabBarView(
        controller: _tabController,
        children: <Widget>[HomePage(), Recommended_screen()],
      )),
    );
  }

  Widget appBar() {
    return AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: null,
        primary: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: TabBar(
            indicatorColor: AppColors.yellow,
            labelColor: AppColors.yellow,
            unselectedLabelColor: AppColors.gray,
            controller: _tabController,
            tabs: myTabs,
            labelPadding: EdgeInsets.symmetric(vertical: 5.0),
          ),
        ));
  }
}
