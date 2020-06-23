import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayer/audioplayer.dart';
import 'package:file/local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/comman/Validation.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/reposetories/image_reposetory.dart';
import 'package:flutter_app1234/reposetories/user_reposetory.dart';
import 'package:flutter_app1234/screens/profile_edit/bloc/profile_edit_bloc.dart';
import 'package:flutter_app1234/utilities/validators.dart';
import 'package:flutter_app1234/widgets/loading_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file/file.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileEditBloc>(
      create: (context) => ProfileEditBloc(
        BlocProvider.of<AppBloc>(context),
        FirebaseUserReposetory(),
        FirebaseImageReposetory(),
      )..add(ProfileEditInit()),
      child: _ProfileEditWidget(),
    );
  }
}

class _ProfileEditWidget extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  _ProfileEditWidget({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _ProfileEditScreen createState() => _ProfileEditScreen();
}

class _ProfileEditScreen extends State<_ProfileEditWidget> {
  //void recored
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController name_controller;
  TextEditingController website_controller;
  String user_birth_date;

  @override
  void initState() {
    super.initState();
    _init();
    final state =
        BlocProvider.of<ProfileEditBloc>(context).state as ProfileEditData;
    name_controller = TextEditingController(text: state.user.username);
    website_controller = TextEditingController(text: state.user.website);
    user_birth_date = state.user.birthday ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        key: _scaffoldKey,
        appBar: appBar(context),
        body: BlocListener<ProfileEditBloc, ProfileEditState>(
          listener: (context, state) {
            if (state is ProfileEditDone) {
              Navigator.of(context).pop();
            }
            if (state is ProfileEditError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Error'),
                action: SnackBarAction(
                    textColor: AppColors.yellow,
                    label: 'Retry',
                    onPressed: () => saveProfileData()),
              ));
            }
          },
          child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
              builder: (context, state) {
            final view = SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: topProfileHeader()));

            if (state is ProfileEditLoading)
              return LoadingContainer(
                child: view,
                loading: true,
              );
            else
              return view;
          }),
        ));
  }

  void openDatePicker() async {
    var order = await getDate(context);
    if (order == null) return;
    // final f = new DateFormat('DD-MM-YYYY');
    // f.format(DateTime(order.year,order.month,order.day))
    setState(() {
      user_birth_date = order.day.toString() +
          " " +
          getMonth(order.month) +
          " " +
          order.year.toString();
    });
  }

  Future<DateTime> getDate(BuildContext context) {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(3030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  /*void recored*/
  _startVoiceRecord() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
      final snackBar = SnackBar(content: Text("Start voice record"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } catch (e) {
      print(e);
    }
  }

  Widget appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontFamily: AppFont.medium),
        ),
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.black,
            onPressed: () {
              saveProfileData();
            },
            child: Text(
              "Save",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.yellow,
                  fontFamily: AppFont.medium),
            ),
          ),
        ]
        // action button
        );
  }

  String getMonth(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }
  }

  Widget webiteWiget() {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(children: <Widget>[
          Text("Website",
              style: TextStyle(
                  color: AppColors.text_light_black,
                  fontSize: 20,
                  fontFamily: AppFont.medium)),
          Flexible(
              child: TextField(
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 16,
                      fontFamily: AppFont.roboto),
                  maxLines: 1,
                  controller: website_controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter website",
                    hintStyle: TextStyle(
                        color: AppColors.gray,
                        fontSize: 16,
                        fontFamily: AppFont.roboto),
                    fillColor: Colors.transparent,
                    filled: true,
                  ))),
        ]));
  }

  Widget birthdayWiget() {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Birthday",
                  style: TextStyle(
                      color: AppColors.text_light_black,
                      fontSize: 20,
                      fontFamily: AppFont.medium)),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    openDatePicker();
                  },
                  child: Text(user_birth_date,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 20,
                          fontFamily: AppFont.medium)),
                ),
              )
            ]));
  }

  Widget bioVoiceWiget() {
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Text("Bio/Voicenote",
                      style: TextStyle(
                          color: AppColors.text_light_black,
                          fontSize: 20,
                          fontFamily: AppFont.medium))),
              Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            _startVoiceRecord();
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.vibration,
                                color: AppColors.yellow,
                              ))),
                      GestureDetector(
                          onTap: () {
                            _stop();
                          },
                          child: Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.vibration,
                                color: AppColors.yellow,
                              )))
                    ],
                  ))
            ]));
  }

  Widget nameWiget() {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Name",
                  style: TextStyle(
                      color: AppColors.text_light_black,
                      fontSize: 20,
                      fontFamily: AppFont.medium)),
              Flexible(
                  child: TextFormField(
                      validator: userNameValidator,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 20,
                          fontFamily: AppFont.medium),
                      maxLines: 1,
                      controller: name_controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter name",
                        hintStyle: TextStyle(
                            color: AppColors.gray,
                            fontSize: 20,
                            fontFamily: AppFont.medium),
                        fillColor: Colors.transparent,
                        filled: true,
                      )))
            ]));
  }

  Widget topProfileHeader() {
    return Column(
      children: <Widget>[
        Align(
            child: GestureDetector(
                onTap: () => BlocProvider.of<ProfileEditBloc>(context)
                    .add(ProfileEditPickImage()),
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75.0),
                      child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
                        builder: (context, state) {
                          if (state.image == null &&
                              state.user.avatarUrl == null)
                            return Image.asset(
                              "assets/Images/empty.png",
                              fit: BoxFit.cover,
                            );
                          if (state.image != null)
                            return Image.file(state.image, fit: BoxFit.cover);
                          return Image.network(state.user.avatarUrl,
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40, bottom: 20),
                    width: 35.0,
                    height: 35.0,
                    decoration: BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                    child: Icon(
                      Icons.camera_enhance,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ]))),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profile Displays",
                  style: TextStyle(
                      color: AppColors.text_light_gray,
                      fontSize: 16,
                      fontFamily: AppFont.roboto),
                ))),
        nameWiget(),
        Divider(),
        bioVoiceWiget(),
        Divider(),
        birthdayWiget(),
        Divider(),
        webiteWiget(),
        Divider(),
      ],
    );
  }

  void saveProfileData() {
    var name = name_controller.text;
    var website = website_controller.text;

    var error = userNameValidator(name);
    if (error != null) {
      final snackBar = SnackBar(content: Text(error));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    if (!Validation.isRequired(website)) {
      final snackBar = SnackBar(content: Text("Enter Website"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    if (!Uri.parse(website).isAbsolute) {
      final snackBar = SnackBar(content: Text("Enter valid website name"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    
    BlocProvider.of<ProfileEditBloc>(context).add(ProfileEditSave(
        name: name, wibsite: website, birthday: user_birth_date));
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
    final snackBar =
        SnackBar(content: Text("Save voice record in your SD card"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
}
