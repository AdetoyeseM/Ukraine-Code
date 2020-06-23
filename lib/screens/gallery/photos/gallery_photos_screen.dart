import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/reposetories/image_reposetory.dart';
import 'package:flutter_app1234/screens/gallery/photos/bloc/gallery_photos_bloc.dart';
import 'package:flutter_app1234/widgets/loading_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class GalleryPhotosScreen extends StatelessWidget {
  final String title;
  final File backgroundImage;

  const GalleryPhotosScreen({Key key, this.backgroundImage, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GalleryPhotosBloc>(
        create: (context) => GalleryPhotosBloc(FirebaseImageReposetory(), title,
            BlocProvider.of<AppBloc>(context).state.user.username),
        child: _GalleryPhotosWidget(backgroundImage: backgroundImage));
  }
}

class _GalleryPhotosWidget extends StatefulWidget {
  final File backgroundImage;

  const _GalleryPhotosWidget({Key key, this.backgroundImage}) : super(key: key);

  @override
  _GalleryPhotosState createState() => _GalleryPhotosState();
}

class _GalleryPhotosState extends State<_GalleryPhotosWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _error;
  List<Asset> images_list = List<Asset>();
  String asset_total_img = "0/15";

  @override
  Widget build(BuildContext context) {
    return BlocListener<GalleryPhotosBloc, GalleryPhotosState>(
      listener: (context, state) {
        if (state is GalleryPhotosDone) {
          Navigator.pop(context, {'success': true});
        }
      },
      child: BlocBuilder<GalleryPhotosBloc, GalleryPhotosState>(
          builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: appBar(state is GalleryPhotosLoading),
          body: LoadingContainer(
            loading: state is GalleryPhotosLoading,
            child: Column(
              children: <Widget>[
                Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "Add photos to gallery",
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
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(widget.backgroundImage,
                                width: 300, height: 200, fit: BoxFit.cover)),
                      ))
                ]),
                Text(
                  asset_total_img,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: AppFont.medium,
                      color: Colors.black),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  height: 150,
                  child: imageBuilder(),
                ),
                Container(
                    margin: EdgeInsets.only(top: 40),
                    child: RawMaterialButton(
                      onPressed: () async {
                        loadAssets();
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
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 15,
        enableCamera: true,
        selectedAssets: images_list,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print("Error =====");
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      print("herre =====");
      if (resultList.length == 0) {
        print(" herre sero size=====");
      } else {
        print(" herre sero notsize=====");
        asset_total_img = resultList.length.toString() + "/15";
        images_list = resultList;
      }

      _error = error;
    });
  }

  Widget appBar(bool isLoading) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: FlatButton(
          textColor: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Gallery',
          style: TextStyle(color: Colors.black, fontFamily: AppFont.medium),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.black,
            onPressed: isLoading
                ? null
                : () {
                    if (images_list.length == 0) {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Add at least one photo')));
                      return;
                    }
                    BlocProvider.of<GalleryPhotosBloc>(context)
                        .add(GalleryPhotosSave(images_list));
                  },
            child: Text(
              "Create",
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.yellow,
                  fontFamily: AppFont.medium),
            ),
          )
        ]);
  }

  Widget imageBuilder() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images_list.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.transparent,
              child: Container(
                //child: Center(child: Image.file(File(images[index]),height:150,width:100,fit:BoxFit.fill)),
                child: Center(
                    child: AssetThumb(
                  asset: images_list[index],
                  width: 300,
                  height: 300,
                )),
              ),
            ),
          );
        });
  }
}
