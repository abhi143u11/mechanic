import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:mechanic/screens/home_screen.dart';
import 'package:provider/provider.dart';

class DoneScreen extends StatefulWidget {
  static const routeName = '/done';
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  bool _isDone = false;
  Timer _timer;
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      _isDone = Provider.of<Mechanic>(context, listen: false).isDone;
      if (!_isDone) {
        _timer = Timer.periodic(new Duration(seconds: 2), (_) async {
          try {
            await Provider.of<Mechanic>(context, listen: false).donePoint();
            _isDone = Provider.of<Mechanic>(context, listen: false).isDone;
            if (_isDone) setState(() {});
          } catch (e) {
            print(e.toString());
            throw e;
          }
        });
      } else {
        setState(() {});
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    if (_timer == null) return;
    _timer.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You Reached '),
      ),
      body: _isDone
          ? Center(
              child: Container(
                height: 300,
                width: double.maxFinite,
                padding: EdgeInsets.all(32),
                child: Card(
                  color: Color(0xfff0f0f0),
                  child: Center(
                    child: Text(
                      'Congartulations! You have Succefully completed one task.',
                      style: successStyle,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text(
                    'Work Under Progress Once Completed it will show here...',
                    style: widgetStyle1,
                  ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _isDone
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Container(
                height: 80.0,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName, (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Move to Home',
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
