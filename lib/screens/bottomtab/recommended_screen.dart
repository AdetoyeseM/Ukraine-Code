import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/comman/style.dart';
import 'package:flutter_app1234/models/InterstedList.dart';

class Recommended_screen extends StatefulWidget {
  @override
  _Recommended_screen createState() => _Recommended_screen();
}

class _Recommended_screen extends State<Recommended_screen> {
  List<InterstedList> interstedList = List<InterstedList>();
  List<InterstedList> bottomList = List<InterstedList>();
  @override
  void initState() {
    // TODO: implement initState
    interstedList.add(InterstedList(
        "https://i.ibb.co/3zxxdcn/download-1.jpg", "500 Active", "#Rap"));
    interstedList.add(InterstedList(
        "https://i.ibb.co/3zxxdcn/download-1.jpg", "2400 Active", "#Roo"));
    interstedList.add(InterstedList(
        "https://i.ibb.co/3zxxdcn/download-1.jpg", "3200 Active", "#R&B"));
    interstedList.add(InterstedList(
        "https://i.ibb.co/3zxxdcn/download-1.jpg  ", "1000 Active", "#R&C"));
    bottomList.add(InterstedList(
        "https://i.ibb.co/gdX92Fh/download.jpg", "1000 Active", "#Star"));
    bottomList.add(InterstedList(
        "https://i.ibb.co/gdX92Fh/download.jpg", "1000 Active", "#Top 100"));
    bottomList.add(InterstedList(
        "https://i.ibb.co/gdX92Fh/download.jpg", "1000 Active", "#Platinum"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Based on your Interests",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.text_light_black,
                        fontFamily: AppFont.medium),
                  ),
                  Icon(Icons.navigate_next)
                ],
              )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 24.0),
            height: 170,
            child: interestWedigt(),
          ),
          Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.whatshot,
                    color: Colors.red,
                    size: 50,
                  ),
                  Text(
                    "Hot",
                    style: TextStyle(
                        fontSize: 30,
                        color: AppColors.text_light_gray,
                        fontFamily: AppFont.extraBold),
                  ),
                  Icon(
                    Icons.whatshot,
                    color: Colors.red,
                    size: 50,
                  )
                ],
              )),
          Text(
            "2.6M CURRENTLY PLAYING",
            style: TextStyle(
                fontSize: 20,
                color: AppColors.text_light_gray,
                fontFamily: AppFont.extraBold),
          ),
          centerImageView(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 24.0),
            height: 150,
            child: bottomWedigt(),
          )
        ],
      )),
    );
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
                  "https://i.ibb.co/R3rrzpj/bilingual-songs.jpg",
                  height: 200,
                  width: 300,
                  fit: BoxFit.cover),
            ),
            Container(
                height: 200,
                width: 300,
                alignment: Alignment.center,
                child: Visibility(
                    visible: true,
                    child: Container(
                        child: Center(
                            child: Text(
                      "King of new york",
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColors.gray,
                        fontFamily: AppFont.extraBold,
                      ),
                    ))))),
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

  Widget interestWedigt() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: interstedList.length,
        itemBuilder: (context, index) {
          return Container(
              width: 130,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 130,
                    alignment: Alignment.topCenter,
                    child: Stack(children: <Widget>[
                      Container(
                          height: 90,
                          width: 130,
                          alignment: Alignment.center,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.network(interstedList[index].img_url,
                                height: 90, width: 130, fit: BoxFit.cover),
                          )),
                      Container(
                          height: 90,
                          width: 130,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Visibility(
                              visible: true,
                              child: Container(
                                  child: Center(
                                      child: Text(
                                interstedList[index].tag,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.gray[100],
                                    fontFamily: AppFont.extraBold),
                              )))))
                    ]),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        interstedList[index].title,
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: AppFont.extraBold,
                            color: AppColors.gray[400]),
                      ))
                ],
              ));
        });
  }

  Widget bottomWedigt() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bottomList.length,
        itemBuilder: (context, index) {
          return Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 90,
                        width: 130,
                        alignment: Alignment.center,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Image.network(bottomList[index].img_url,
                              height: 90, width: 130, fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                          height: 90,
                          width: 130,
                          alignment: Alignment.center,
                          child: Visibility(
                              visible: true,
                              child: Container(
                                  child: Center(
                                      child: Text(
                                bottomList[index].tag,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.gray[100],
                                    fontFamily: AppFont.extraBold),
                              ))))),
                    ],
                  )));
        });
  }
}
