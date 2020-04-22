import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:mechanic/screens/done_screen.dart';
import 'package:mechanic/widgets/customer_deatils.dart';
import 'package:provider/provider.dart';

class ReachScreen extends StatefulWidget {
  static const routeName = '/reach';
  @override
  _ReachScreenState createState() => _ReachScreenState();
}

class _ReachScreenState extends State<ReachScreen> {
  bool _isCancel;
  Timer _timer;
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      _isCancel = Provider.of<Mechanic>(context, listen: false).isCancel;
      if (!_isCancel) {
        _timer = Timer.periodic(new Duration(seconds: 2), (_) async {
          try {
            await Provider.of<Mechanic>(context, listen: false)
                .mechaCancelCheckPoint();
            _isCancel = Provider.of<Mechanic>(context, listen: false).isCancel;
            if (_isCancel)
              setState(() {
                _timer.cancel();
              });
          } catch (e) {
            throw e;
          }
        });
      } else {
        setState(() {
          _timer.cancel();
        });
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
        title: Text('Mechanic on the way'),
      ),
      body: Column(
        children: <Widget>[
          CustomerDetail(_isCancel),
          Container(
            margin: EdgeInsets.all(16),
            child: _isCancel
                ? RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Customer has canceled this order, Click to Move to Home!',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                  )
                : Text(
                    'If Customer cancel this order it we will be notified to you here !!',
                    style: widgetStyle1,
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 80.0,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: _isCancel
                ? null
                : () async {
                    await Provider.of<Mechanic>(context, listen: false)
                        .mechaReach();
                    Navigator.pushNamed(context, DoneScreen.routeName);
                  },
            child: Text(
              'Plaese Click This Button, Once You Reach Customer\'s Location',
              style: widgetStyle1,
            ),
          ),
        ),
      ),
    );
  }
}
