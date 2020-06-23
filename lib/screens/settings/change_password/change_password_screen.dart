import 'package:flutter/material.dart';
import 'package:flutter_app1234/comman/appfont.dart';
import 'package:flutter_app1234/screens/settings/account/bloc/settings_account_bloc.dart';
import 'package:flutter_app1234/screens/settings/change_password/bloc/change_password_bloc.dart';
import 'package:flutter_app1234/services/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordBloc>(
        create: (context) => ChangePasswordBloc(AuthService()),
        child: _ChangePasswordWidget());
  }
}

class _ChangePasswordWidget extends StatefulWidget {
  _ChangePasswordWidget({Key key}) : super(key: key);

  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<_ChangePasswordWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController;
  TextEditingController newPasswordController;

  @override
  void initState() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSaved) {
          Navigator.pop(context);
        }
        if (state is ChangePasswordError) {
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
          builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              'Change Password',
              style: TextStyle(color: Colors.black, fontFamily: AppFont.medium),
            ),
            leading: IconButton(
              icon: Icon(Icons.navigate_before, color: Colors.black),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            actions: [
              FlatButton(
                child: Text('Save'),
                disabledColor: Colors.grey,
                textColor: Colors.blue,
                onPressed: state is ChangePasswordLoading
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          BlocProvider.of<ChangePasswordBloc>(context)
                              .add(ChangePasswordSave(
                            oldPasswordController.text,
                            newPasswordController.text,
                          ));
                        }
                      },
              )
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: oldPasswordController,
                      autofocus: true,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) return 'Enter current password';
                        return null;
                      },
                      decoration:
                          InputDecoration(labelText: 'Current password'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: newPasswordController,
                      autofocus: true,
                      validator: (value) {
                        if (value.isEmpty) return 'Enter new password';
                        if (value.length < 6)
                          return 'New password is too short';
                        return null;
                      },
                      decoration:
                          InputDecoration(labelText: 'Type new password'),
                    )
                  ]),
                ),
              ),
              if (state is ChangePasswordLoading)
                Positioned.fill(
                    child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator()),
                ))
            ],
          ),
        );
      }),
    );
  }
}
