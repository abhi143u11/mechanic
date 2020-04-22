import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/auth.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:mechanic/screens/reach_screen.dart';
import 'package:mechanic/widgets/customer_deatils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _indicator;
  bool isInit = true;
  String _userId;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initstate");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print(dispose);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("deactivate");
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    // TODO: implement didUpdateWidget
//    if(_timer == null) return;
//    _timer.cancel();
    super.didUpdateWidget(oldWidget);
    print("update widget called");
  }

  @override
  void didChangeDependencies() async {
    print("didchange dependency");
    if (isInit) {
      _userId = Provider.of<Auth>(context, listen: false).userId;
      _indicator = Provider.of<Mechanic>(context, listen: false).indicator;
      if (!_indicator) {
        try {
          print('checkpoint');
          await Provider.of<Mechanic>(context, listen: false)
              .checkPoint(_userId);
        } catch (e) {
          print(e.toString());
          throw e;
        }
        _timer = Timer.periodic(new Duration(seconds: 3), (timer) async {
//            await Provider.of<Auth>(context, listen: false).getLocation();
//            await Provider.of<Auth>(context, listen: false).updateLocation();
          if (timer.isActive) {
            try {
              print('checkpoint');
              await Provider.of<Mechanic>(context, listen: false)
                  .checkPoint(_userId);
            } catch (e) {
              print(e.toString());
              throw e;
            }
          }
          print(timer.tick);
        });
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

//  @override
//  void deactivate() {
//    _timer.cancel();
//    super.deactivate();
//  }

  @override
  Widget build(BuildContext context) {
    _indicator = Provider.of<Mechanic>(context).indicator;
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
      body: _indicator
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'A customer has reached you !! ',
                          style: successStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'If any customer will contact, then notification will be  shown below.',
                    style: widgetStyle1,
                    maxLines: 3,
                  ),
                ),
                Text(
                  'No Customer Contacted you',
                  style: widgetStyle1,
                ),
                SizedBox()
              ],
            ),
      bottomNavigationBar: _indicator
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Container(
                height: 80.0,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    try {
                      await Provider.of<Mechanic>(context, listen: false)
                          .mechaArrival();
                      Navigator.pushNamed(context, ReachScreen.routeName);
                    } catch (e) {
                      print(e.toString());
                      throw e;
                    }
                  },
                  child: Text(
                    'View Custome Details',
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
}
