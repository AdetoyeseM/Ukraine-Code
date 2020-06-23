import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/models/TrendingList.dart';

class UserFavouriteScreen extends StatefulWidget {
  @override
  _UserFavouriteScreen createState() => _UserFavouriteScreen();
}

class _UserFavouriteScreen extends State<UserFavouriteScreen> {
  List<TrendingList> trendingList = List<TrendingList>();
  @override
  void initState() {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: _myListView(context),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      //  physics:  NeverScrollableScrollPhysics(), //AlwaysScrollableScrollPhysics
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
}
