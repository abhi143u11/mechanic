import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/models/mechanic.dart';
import 'package:mechanic/providers/auth.dart';
import 'package:mechanic/screens/home_screen.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  Mechanic mechanic = Mechanic();
  bool _isInit = true;
  String _errorMsg = '';
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      await Provider.of<Auth>(context, listen: false).getLocation();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter name!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mechanic.name = value;
                  },
                ),
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
                    mechanic.email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mobile'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Invalid number!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mechanic.mobileno = value;
                  },
                ),
                TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(labelText: "Address"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter your address";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mechanic.address = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mechanic.password = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        checkbox("Bike", mechanic.bike),
                        checkbox("Car", mechanic.car),
                        checkbox("Bus", mechanic.bus),
                        checkbox("Truck", mechanic.truck),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        checkbox("Tractor", mechanic.tacter),
                        checkbox("Auto", mechanic.autoer),
                        checkbox("Organisation", mechanic.org),
                        checkbox("Toe", mechanic.toe),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text('SIGN UP'),
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
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    },
                    child: Center(
                      child: Container(
                          margin: EdgeInsets.all(16),
                          child: Text(
                            'Instead Login',
                            style: widgetStyle1,
                          )),
                    )),
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
    );
  }

  Widget checkbox(String title, bool boolValue) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: widgetStyle2,
        ),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            setState(() {
              switch (title) {
                case "Bike":
                  mechanic.bike = value;
                  break;
                case "Car":
                  mechanic.car = value;
                  break;
                case "Bus":
                  mechanic.bus = value;
                  break;
                case "Truck":
                  mechanic.truck = value;
                  break;
                case "Tractor":
                  mechanic.tacter = value;
                  break;
                case "Auto":
                  mechanic.autoer = value;
                  break;
                case "Toe":
                  mechanic.toe = value;
                  break;
                case "Organisation":
                  mechanic.org = value;
              }
            });
          },
        ),
      ],
    );
  }

  _submit() async {
    _errorMsg = null;
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(mechanic.mobileno);
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signup(mechanic);
      _errorMsg = Provider.of<Auth>(context, listen: false).errorMsg.toString();
      if (_errorMsg.contains("error")) {
        setState(() {});
        return;
      }
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (e) {
      print(e.toString());
      setState(() {
        _errorMsg = e.toString();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }
}
