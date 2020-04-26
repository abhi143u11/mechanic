import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/auth.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:mechanic/screens/menu.dart';
import 'package:mechanic/screens/reach_screen.dart';
import 'package:mechanic/widgets/customer_deatils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isInit = true;
  bool _isLoading = false;
  int counter = 0;

  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: null,
    );
  }

  @override
  void didChangeDependencies() async {
    if (isInit) {
      Provider.of<Auth>(context, listen: false).getLocation();
      final mechanic = Provider.of<Mechanic>(context);
      final data = Provider.of<Mechanic>(context, listen: false);
      Timer.periodic(new Duration(seconds: 2), (timer) async {
        print(timer.tick);
        Provider.of<Auth>(context, listen: false).updateLocation();
        bool _indicator = mechanic.indicator;
        bool _isCancel = mechanic.isCancel;
        if (_indicator && counter == 0) {
          _showNotificationWithDefaultSound();
          counter = 1;
        }
        if (_isCancel) {
          counter = 0;
          setState(() {});
        }
        if (_indicator) {
          await data.mechaCancelCheckPoint();
        } else if (!_indicator) {
          await data.checkPoint();
        }
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    counter = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mechanic = Provider.of<Mechanic>(context);
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            tooltip: 'logout',
            icon: Icon(Icons.subdirectory_arrow_right),
            onPressed: () async {
              try {
                await Provider.of<Auth>(context, listen: false).logout(context);
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              } catch (e) {
                print(e);
                throw e;
              }
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: mechanic.indicator && !mechanic.isCancel
          ? Visibility(
              visible: mechanic.indicator,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildContainer(auth),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(64),
                    child: Text(
                      'A customer has reached you !! ',
                      textAlign: TextAlign.center,
                      style: dataStyle1,
                    ),
                  ),
                ],
              ),
            )
          : Visibility(
              visible: !mechanic.indicator || mechanic.isCancel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  buildContainer(auth),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'If any customer will contact, then notification will be  shown below.',
                      textAlign: TextAlign.center,
                      style: widgetStyle1,
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No Customer Contacted you!',
                      textAlign: TextAlign.center,
                      style: widgetStyle1,
                    ),
                  ),
                  SizedBox()
                ],
              ),
            ),
      bottomNavigationBar: mechanic.indicator && !mechanic.isCancel
          ? BottomAppBar(
              child: Container(
                height: 80.0,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _isLoading
                      ? null
                      : () async {
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await Provider.of<Mechanic>(context, listen: false)
                                .mechaArrival();
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushNamed(context, ReachScreen.routeName);
                          } catch (e) {
                            print(e.toString());
                            throw e;
                          }
                        },
                  child: Text(
                    _isLoading ? 'Please Wait' : 'View Custome Details',
                    style: widgetStyle1,
                  ),
                ),
              ),
            )
          : BottomAppBar(
              child: SizedBox(),
            ),
    );
  }

  Container buildContainer(Auth auth) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(32),
      padding: EdgeInsets.all(32),
      child: Text(
        'Welcome ${auth.name}',
        textAlign: TextAlign.center,
        style: dataStyle1,
      ),
    );
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Hi, ${Provider.of<Auth>(context, listen: false).name}',
      'A Customer has called you!',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
