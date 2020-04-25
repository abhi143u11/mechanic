import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:mechanic/screens/done_screen.dart';
import 'package:mechanic/screens/map_screen.dart';
import 'package:mechanic/widgets/customer_deatils.dart';
import 'package:provider/provider.dart';

class ReachScreen extends StatefulWidget {
  static const routeName = '/reach';
  @override
  _ReachScreenState createState() => _ReachScreenState();
}

class _ReachScreenState extends State<ReachScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final mechanic = Provider.of<Mechanic>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff0f0f0),
        title: Text('Customer Detail'),
      ),
      body:  mechanic.longitude != null ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CustomerDetail(mechanic.latitude, mechanic.longitude),
          RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text(
              'View Route on Map',
              style: widgetStyle1,
            ),
            onPressed: mechanic.isCancel
                ? null
                : () {
                    Navigator.of(context).pushNamed(MapScreen.routeName,
                        arguments: [mechanic.latitude, mechanic.longitude]);
                  },
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: mechanic.isCancel
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
      ) : Container(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 80.0,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: mechanic.isCancel || _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Mechanic>(context, listen: false)
                        .mechaReach();
                    setState(() {
                      _isLoading=false;
                    });
                    Navigator.pushNamed(context, DoneScreen.routeName);
                  },
            child: Text(
              _isLoading ? 'Please wait...': 'Plaese Click This Button, Once You Reach Customer\'s Location',
              style: widgetStyle1,
            ),
          ),
        ),
      ),
    );
  }
}
