import 'package:flutter/material.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/auth.dart';
import 'package:mechanic/screens/home_screen.dart';
import 'package:mechanic/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMsg;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text('LOGIN IN'),
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 64.0, vertical: 16.0),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button.color,
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(
                                  context, SignupScreen.routeName);
                            },
                      child: Text('SING UP INSTEAD')),
                  _errorMsg != null
                      ? Text(
                          _errorMsg,
                          style: errorStyle,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit() async {
    _errorMsg = null;
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    print(_authData);
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['email'], _authData['password']);
      _errorMsg = Provider.of<Auth>(context, listen: false).errorMsg;
      if (_errorMsg != null) {
        setState(() {});
      }
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
