import 'dart:io';

import 'package:firebase_chat_app/widget/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function submitForm;
  final bool isLoading;

  AuthForm(this.submitForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail;
  var _userName;
  var _userPassword;
  var _userImage;

  void _pickedUserImage(File file) {
    _userImage = file;
  }

  void _trySubmit(BuildContext context) {
    final validate = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _userImage == null) {
      showError(context, 'Please pick an image');
      return;
    }
    if (!validate) {
      showError(context, 'Please enter all data.');
      return;
    }
    _form.currentState.save();
    widget.submitForm(
        _userEmail.trim(), _userPassword, _userName, _isLogin, context, _userImage);
  }

  void showError(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(
          20,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              16,
            ),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedUserImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@"))
                        return 'Please Enter A Valid Email Address';
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4)
                          return 'Username at least must be 7 character long.';
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7)
                        return 'Password at least must be 7 character long.';
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text(
                            _isLogin ? 'Login' : 'Sign Up',
                          ),
                          onPressed: () {
                            _trySubmit(context);
                          },
                        ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        _isLogin
                            ? 'Create new Account'
                            : 'I already have an account',
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
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
