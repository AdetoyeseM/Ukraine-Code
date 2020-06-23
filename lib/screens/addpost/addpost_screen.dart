import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/AppColors.dart';
import 'package:flutter_app1234/data/models/post.dart';
import 'package:flutter_app1234/main.dart';
import 'package:flutter_app1234/reposetories/image_reposetory.dart';
import 'package:flutter_app1234/reposetories/post_reposetory.dart';
import 'package:flutter_app1234/screens/addpost/bloc/addpost_bloc.dart';
import 'package:flutter_app1234/widgets/loading_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddpostScreen extends StatelessWidget {
  const AddpostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddpostBloc>(
        create: (context) => AddpostBloc(
              FirebasePostReposetory(),
              FirebaseImageReposetory(),
              BlocProvider.of<AppBloc>(context).state.user,
            ),
        child: _AddpostWidget());
  }
}

class _AddpostWidget extends StatefulWidget {
  _AddpostWidget({Key key}) : super(key: key);

  @override
  _AddpostWidgetState createState() => _AddpostWidgetState();
}

class _AddpostWidgetState extends State<_AddpostWidget> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocListener<AddpostBloc, AddpostState>(
      listener: (context, state) {
        if (state is AddpostSaved) {
          Navigator.pop(context, state.post);
        }
        if (state is AddpostError) {
          scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text('Error')));
        }
      },
      child: BlocBuilder<AddpostBloc, AddpostState>(
        builder: (context, state) => Scaffold(
          key: scaffoldKey,
          body: SafeArea(
            child: LoadingContainer(
              loading: state is AddpostLoading,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlatButton(
                        child: Text('Cancel'),
                        textColor: AppColors.yellow,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: RaisedButton(
                            child: Text('Post'),
                            textColor: AppColors.white,
                            color: AppColors.yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            onPressed: () {
                              if (_controller.text.length > 0 ||
                                  state.photos.length > 0) {
                                BlocProvider.of<AddpostBloc>(context).add(
                                    AddPostCreate(
                                        PostModel(text: _controller.text)));
                              }
                            }),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextFormField(
                            controller: _controller,
                            textInputAction: TextInputAction.newline,
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                prefixIcon: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: Image.asset(
                                          'assets/Images/OriginalLogoBRAINLOGO.png',
                                          fit: BoxFit.contain,
                                          scale: 2,
                                          height: 30,
                                          width: 30),
                                    ),
                                  ],
                                ),
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 18),
                                hintText: 'What\'s happening?'),
                          ))),
                  Container(
                    height: 96,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.grey[300], width: 1)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                ImagePicker.pickImage(
                                        source: ImageSource.gallery)
                                    .then((value) {
                                  if (value != null) {
                                    BlocProvider.of<AddpostBloc>(context)
                                        .add(AddPostAddPhoto([value]));
                                  }
                                });
                              },
                              child: Center(
                                child: Icon(Icons.camera_alt,
                                    size: 38, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (state.photos.length > 0)
                        ...state.photos
                            .map<Widget>((e) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                        width: 80,
                                        height: 80,
                                        child: GestureDetector(
                                            child: Image.file(e,
                                                fit: BoxFit.cover),
                                            onTap: () =>
                                                BlocProvider.of<AddpostBloc>(
                                                    context)
                                                  ..add(AddPostRemovePhoto(
                                                      file: e)))),
                                  ),
                                ))
                            .toList()
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
