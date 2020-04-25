import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:provider/provider.dart';

class DoneScreen extends StatefulWidget {
  static const routeName = '/done';
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  Timer _timer;
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      final mechanic = Provider.of<Mechanic>(context);
        _timer = Timer.periodic(new Duration(seconds: 1), (_) async {
            await mechanic.donePoint();
        });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {

    if (_timer == null) return;
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isDone = Provider.of<Mechanic>(context).isDone;
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
                    Provider.of<Mechanic>(context,listen: false).setDone(false);
                    Provider.of<Mechanic>(context,listen: false).setIndicator(false);
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
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
