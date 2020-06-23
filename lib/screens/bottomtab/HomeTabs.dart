import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/screens/gallery/background/gallery_background_screen.dart';
import 'package:flutter_app1234/screens/home/home_screen.dart';
import 'package:flutter_app1234/screens/bottomtab/inbox_screen.dart';
import 'package:flutter_app1234/screens/profile/profile_screen.dart';
import 'package:flutter_app1234/screens/search/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabs extends StatefulWidget {
  HomeTabs() : super();

  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        bottomNavigationBar: new Material(
          child: tabarWiget(),
          color: Colors.white,
        ),
        body: new TabBarView(
          children: <Widget>[
            new HomeScreen(),
            SearchScreen(),
            GalleryBackgroundScreen(),
            new InboxScreen(),
            ProfileScreen(
                userId: BlocProvider.of<AppBloc>(context).state.user.id),
          ],
          controller: controller,
        ));
  }

  Widget tabarWiget() {
    return new SafeArea(
        child: new TabBar(
      indicatorColor: AppColors.yellow,
      labelColor: AppColors.yellow,
      unselectedLabelColor: AppColors.gray,
      tabs: <Tab>[
        new Tab(
          icon: new Icon(Icons.home),
        ),
        new Tab(
          icon: new Icon(Icons.search),
        ),
        new Tab(
            child: Container(
          //width: 100.0,
          height: 40.0,
          width: 200,
          decoration: new BoxDecoration(
            color: AppColors.yellow,
            border: new Border.all(color: Colors.white, width: 2.0),
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: new Center(
            child: ImageIcon(AssetImage("assets/Images/timer.png"),
                color: Colors.white),
          ),
        )),
        // new Tab(icon: new Icon(Icons.search),child:Text('test',style: TextStyle(fontFamily: AppFont.roboto,fontSize: 12)) ,),
        new Tab(
          icon: ImageIcon(
            AssetImage(
              "assets/Images/inbox.png",
            ),
          ),
        ),
        // new Tab(icon: new Icon(Icons.account_circle),child:Text('Me',style: TextStyle(fontFamily: AppFont.roboto,fontSize: 12)) ,),
        new Tab(
          icon: ImageIcon(
            AssetImage(
              "assets/Images/profilepageicon.png",
            ),
            color: AppColors.gray,
          ),
        ),
      ],
      controller: controller,
    ));
  }
}
