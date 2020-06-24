import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/PlayerWidgetMy.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/models/TrendingList.dart';
import 'package:flutter_app1234/reposetories/post_reposetory.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:flutter_app1234/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_app1234/screens/profile_edit/profile_edit_screen.dart';
import 'package:flutter_app1234/screens/user_privacy_setting/privancy_and_settting_screen.dart';
import 'package:flutter_app1234/users/bloc/users_bloc.dart';
import 'package:flutter_app1234/users/users_screen.dart';
import 'package:flutter_app1234/utilities/big_number_convertor.dart';
import 'package:flutter_app1234/widgets/error_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/user_post/bloc/user_post_bloc.dart';
import 'pages/user_post/user_post_page.dart';

const tabCount = 3;

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
            FirebaseUserReposetory(), BlocProvider.of<AppBloc>(context))
          ..add(ProfileInit(userId)),
        child: _ProfuleWidget(userId: userId));
  }
}

class ProfleTabBarDelegate extends SliverPersistentHeaderDelegate {
  ProfleTabBarDelegate({this.controller});

  final TabController controller;

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).cardColor,
      height: kToolbarHeight,
      child: new TabBar(
        controller: controller,
        indicatorColor: AppColors.yellow,
        labelColor: AppColors.yellow,
        unselectedLabelColor: AppColors.gray,
        key: new PageStorageKey<Type>(TabBar),
        tabs: <Widget>[
          Tab(text: 'Posts'),
          Tab(text: 'Favorites'),
          Tab(text: 'Galleries'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ProfleTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

class _ProfuleWidget extends StatefulWidget {
  final String userId;

  const _ProfuleWidget({Key key, this.userId}) : super(key: key);

  @override
  _ProfuleWidgetState createState() => _ProfuleWidgetState();
}

class _ProfuleWidgetState extends State<_ProfuleWidget>
    with TickerProviderStateMixin {
  List<TrendingList> trendingList = List<TrendingList>();
  var url_song = "https://luan.xyz/files/audio/ambient_c_motion.mp3";

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Posts'),
    Tab(text: 'Favorites'),
    Tab(text: 'Galleries'),
  ];

  TabController _tabController;
  List<Widget> _randomChildren;
  ScrollController _scrollController;

  @override
  void initState() {
    _tabController = TabController(length: tabCount, vsync: this);
    _scrollController = ScrollController();
    // TODO: implement initState
    trendingList.add(TrendingList(
        "https://i.ibb.co/5RSsJgv/main-qimg-6019f398435c62d5315527ef59e8e6ab.png",
        "Devid mark",
        "January 8,2020"));
    trendingList.add(TrendingList(
        "https://i.ibb.co/5RSsJgv/main-qimg-6019f398435c62d5315527ef59e8e6ab.png",
        "Petey Cruiser",
        "February 1,2020"));
    trendingList.add(TrendingList(
        "https://i.ibb.co/5RSsJgv/main-qimg-6019f398435c62d5315527ef59e8e6ab.png",
        "Anna Mull",
        "February 15,2020"));
    trendingList.add(TrendingList(
        "https://i.ibb.co/5RSsJgv/main-qimg-6019f398435c62d5315527ef59e8e6ab.png",
        "Paige Turner",
        "March 5,2020"));
    trendingList.add(TrendingList(
        "https://i.ibb.co/5RSsJgv/main-qimg-6019f398435c62d5315527ef59e8e6ab.png",
        "Bob Frapples.",
        "April 10,2020"));
    trendingList.add(TrendingList(
        "https://i.ibb.co/5RSsJgv/main-qimg-6019f398435c62d5315527ef59e8e6ab.png",
        "Brock Lee",
        "April 20,2020"));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is ProfileLoading)
          return Center(child: CircularProgressIndicator());

        if (state is ProfileData)
          return SafeArea(
              child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _topHeaderWidgets(context, state),
                          childCount: 1,
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate:
                            ProfleTabBarDelegate(controller: _tabController),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: <Widget>[
                      BlocProvider<UserPostBloc>(
                          create: (context) => UserPostBloc(
                              FirebasePostReposetory(),
                              state.user,
                              state.isCurrentUser)
                            ..add(UserPostLoad()),
                          child: UserPostPage()),
                      _myFavouriteView(context),
                      _userGallerisView(context),
                    ],
                    controller: _tabController,
                  )));

        return ErrorContainer(
            onRepeat: () => BlocProvider.of<ProfileBloc>(context)
                .add(ProfileInit(widget.userId)));
      }),
    );
  }

  Widget rowLayout(TrendingList trendingList) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Container(
                    width: 50,
                    height: 50,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(
                                "https://i.ibb.co/7CjZMnS/images-1.jpg")))),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            trendingList.user_name,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: AppFont.medium,
                                color: AppColors.text_light_gray),
                          )),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("2.3M people currenly playing",
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppFont.extraBold,
                                  color: AppColors.text_light_black))),
                    ],
                  ),
                )),
                Text("#1 ",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppFont.extraBold,
                        color: AppColors.gray)),
              ],
            )),
        centerImageView(),
        Container(
            margin: EdgeInsets.only(right: 25),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(trendingList.date,
                  style: TextStyle(
                      fontFamily: AppFont.medium,
                      fontSize: 16,
                      color: Colors.black)),
            ))
      ],
    ));
  }

  Widget centerImageView() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 200,
              width: 300,
              alignment: Alignment.center,
              child: Image.network(
                  "https://i.ibb.co/5RSsJgv/main-qimg-6019f398435c62d5315527ef59e8e6ab.png",
                  height: 200,
                  width: 300,
                  fit: BoxFit.cover),
            ),
            Container(
                height: 200,
                width: 300,
                alignment: Alignment.topCenter,
                child: Visibility(
                    visible: true,
                    child: Container(
                        child: Text(
                      "King of new york",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: AppFont.extraBold,
                      ),
                    )))),
            Container(
                height: 200,
                width: 300,
                padding: EdgeInsets.all(2),
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: AppColors.yellow,
                    child: Text(
                      "Join",
                      style:
                          TextStyle(fontSize: 20, fontFamily: AppFont.medium),
                    ),
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                  ),
                ))
          ],
        ));
  }

  /*============user Wins==========*/
  Widget _WinWiget() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), //AlwaysScrollableScrollPhysics
      itemCount: trendingList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: rowLayout(trendingList[index]),
        );
      },
    );
  }

  /*================Favorite=====================*/
  Widget _myFavouriteView(BuildContext context) {
    return ListView.builder(
      //  physics:  NeverScrollableScrollPhysics(), //AlwaysScrollableScrollPhysics
      itemCount: trendingList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: rowLayoutFavourite(trendingList[index]),
        );
      },
    );
  }

  Widget rowLayoutFavourite(TrendingList trendingList) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Container(
                    width: 50,
                    height: 50,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(
                                "https://i.ibb.co/7CjZMnS/images-1.jpg")))),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            trendingList.user_name,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: AppFont.medium,
                                color: AppColors.text_light_gray),
                          )),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("2.3M people currenly playing",
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppFont.extraBold,
                                  color: AppColors.text_light_black))),
                    ],
                  ),
                )),
                Text("#1 ",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppFont.extraBold,
                        color: AppColors.gray)),
              ],
            )),
        centerImageView(),
      ],
    ));
  }

  /*====================================*/
  Widget _userGallerisView(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("User Galleries screen"),
      ),
    );
  }

  Widget _userProfileWiget(ProfileData state) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              height: 200,
            ),
          ),
          Container(
            width: 120.0,
            height: 120.0,
            child: new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: state.user.avatarUrl != null
                                ? NetworkImage(state.user.avatarUrl)
                                : AssetImage('assets/Images/empty.png')))),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 35.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(flex: 1, child: PlayerWidgetMy(url: url_song))
        ],
      ),
    );
  }

  Widget _changeEditProfileWiget() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: RaisedButton(
          child: Text(
            "Change Profile",
            style: TextStyle(
                color: AppColors.yellow,
                fontFamily: AppFont.extraBold,
                fontSize: 16),
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileEditScreen()));
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(color: AppColors.yellow)),
          color: Colors.white,
          textColor: AppColors.yellow,
          padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
        ));
  }

  Widget _followWiget(ProfileData state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UsersScreen(
                      userId: state.user.id,
                      title: 'Subscriptions',
                      userType: UserType.subscribers))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                    "${bigNumberConvert(state.user.subscriptions)} subscriptions",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UsersScreen(
                        userId: state.user.id,
                        title: 'Followers',
                        userType: UserType.followers))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                      "${bigNumberConvert(state.user.followers)} followers",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              if (!state.isCurrentUser)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: state.following ? Colors.grey : Colors.white,
                      child: InkWell(
                        enableFeedback: !state.following,
                        onTap: () => BlocProvider.of<ProfileBloc>(context).add(
                            state.followed
                                ? ProfileUnfollow()
                                : ProfileFollow()),
                        child: Container(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                            child: Text(
                              state.followed ? "Unfollow" : "Follow",
                              style: TextStyle(
                                  fontFamily: AppFont.extraBold, fontSize: 16),
                            )),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                  )
                ],
              ),
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _topHeaderWidgets(BuildContext context, ProfileData state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    icon: Icon(state.isCurrentUser
                        ? Icons.settings
                        : Icons.arrow_back_ios),
                    onPressed: () {
                      if (state.isCurrentUser) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PrivancySettingScreen()));
                      } else {
                        Navigator.pop(context);
                      }
                    }),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Center(
                      child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      state.user.username,
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.text_light_black,
                          fontFamily: AppFont.medium),
                    ),
                  )))
            ],
          ),
          _userProfileWiget(state),
          _followWiget(state),
          if (state.isCurrentUser) _changeEditProfileWiget(),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "This is an example of a description",
                style: TextStyle(
                    color: AppColors.text_light_black,
                    fontSize: 14,
                    fontFamily: AppFont.roboto),
              )),
        ],
      ),
    );
  }
}
