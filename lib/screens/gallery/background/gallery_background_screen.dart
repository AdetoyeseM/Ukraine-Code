import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/screens/gallery/photos/gallery_photos_screen.dart';
import 'package:image_picker/image_picker.dart';

class GalleryBackgroundScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GalleryBackgroundState();
  }
}

class _GalleryBackgroundState extends State<GalleryBackgroundScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  File imageFile;
  var _firstPress = true;
  TextEditingController txt;
  var center_txt_Visible = true;

  @override
  void initState() {
    super.initState();
    txt = TextEditingController();
  }

  @override
  void dispose() {
    txt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: appBar(context),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Text(
                "Choose a background cover",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: AppFont.medium),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 40),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: showImage(),
                )),
            Container(
                margin: EdgeInsets.only(top: 40),
                child: RawMaterialButton(
                  onPressed: () async {
                    setState(() {
                      center_txt_Visible = true;
                    });
                  },
                  child: Text("Add Title",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppFont.medium,
                      )),
                )),
            Container(
                margin: EdgeInsets.only(top: 40),
                child: RawMaterialButton(
                  onPressed: () async {
                    pickImageFromGallery(ImageSource.gallery);
                  },
                  elevation: 2.0,
                  fillColor: AppColors.yellow,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ))
          ]),
        )));
  }

  void pickcerOpen() {
    pickImageFromGallery(ImageSource source) async {
      imageFile = await ImagePicker.pickImage(source: source);
      setState(() {});
    }
  }

  Widget showImageNetwork() {
    if (imageFile != null) {
      return Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://flutter-examples.com/wp-content/uploads/2019/09/sample_image.jpg"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: TextField(
          obscureText: true,
          controller: txt,
          decoration: InputDecoration(
            labelText: 'Enter text',
          ),
        ),
      );
    } else {
      return const Text(
        'No Image Selected',
        textAlign: TextAlign.center,
      );
    }
  }

/*  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return  ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child:
              Image.file(
                  snapshot.data,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover
              ));

        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }*/
  Widget showImage() {
    if (imageFile != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 200,
                width: 300,
                alignment: Alignment.center,
                child: Image.file(imageFile,
                    height: 200, width: 300, fit: BoxFit.cover),
              ),
              Container(
                  height: 200,
                  width: 300,
                  alignment: Alignment.center,
                  child: Visibility(
                      visible: center_txt_Visible,
                      child: Container(
                          child: Center(
                              child: TextField(
                                  controller: txt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: AppFont.medium),
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter a message",
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontFamily: AppFont.medium),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                  )))))),
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
    } else {
      return const Text(
        'No Image Selected',
        textAlign: TextAlign.center,
      );
    }
  }

  pickImageFromGallery(ImageSource source) async {
    imageFile = await ImagePicker.pickImage(source: source);
    setState(() {});
  }

  Widget CenterOverlap() {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.network(
              'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                'Text Message',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0),
              )),
        ],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Gallery',
          style: TextStyle(color: Colors.black, fontFamily: AppFont.medium),
        ),
        leading: Center(
            child: Text(
          ' Cancel',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontFamily: "Medium"),
        )),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.black,
            onPressed: () {
              if (txt.text.length == 0) {
                _scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text('Type Title')));
                return;
              }
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => GalleryPhotosScreen(
                            title: txt.text,
                            backgroundImage: imageFile,
                          )))
                  .then((value) {
                if (value != null) {
                  txt.text = '';
                  setState(() {
                    imageFile = null;
                    _firstPress = true;
                  });
                }
              });
            },
            child: Text(
              "Next",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: AppFont.medium),
            ),
          ),
        ]);
  }
}
