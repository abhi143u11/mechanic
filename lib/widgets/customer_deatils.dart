import 'package:flutter/material.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:mechanic/screens/map_screen.dart';
import 'package:provider/provider.dart';

class CustomerDetail extends StatefulWidget {
  final bool isCancel;
  CustomerDetail(this.isCancel);
  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  @override
  Widget build(BuildContext context) {
    final mechanic = Provider.of<Mechanic>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      color: Colors.grey,
      child: Container(
        padding: EdgeInsets.all(16),
        height: 230,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Text(
              'Customer Deatils',
              style: widgetStyle3,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'name : ${mechanic.name}',
              style: widgetStyle1,
            ),
            Text(
              'address : ',
              style: widgetStyle1,
            ),
            Text(
              'distance : ${mechanic.distance.toStringAsFixed(1)} Km',
              style: widgetStyle1,
            ),
            Text(
              'time : ${mechanic.time.toStringAsFixed(1)} hr',
              style: widgetStyle1,
            ),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              onPressed: widget.isCancel
                  ? null
                  : () {
                      Navigator.of(context).pushNamed(MapScreen.routeName);
                    },
              child: Text(
                'Go to Map',
                style: widgetStyle1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
