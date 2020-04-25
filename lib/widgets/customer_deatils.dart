import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic/constants.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:provider/provider.dart';

class CustomerDetail extends StatefulWidget {
  final double latitude;
  final double longitude;
  CustomerDetail(this.latitude, this.longitude);
  @override
  _CustomerDetailState createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  List<Placemark> placemark;

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  void getAddress() async {
    placemark = await Geolocator()
        .placemarkFromCoordinates(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final mechanic = Provider.of<Mechanic>(context);

    return Container(
      height: MediaQuery.of(context).size.height * .25,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Name', style: dataStyle1),
                  Text('Distance', style: dataStyle1),
                  Text('Time', style: dataStyle1),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(mechanic.name, style: dataStyle2),
                  Text('${mechanic.distance.toStringAsFixed(1)} Km', style: dataStyle2),
                  Text('${mechanic.time.toStringAsFixed(1)} hr', style: dataStyle2)
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Address',
                style: dataStyle1,
              ),
              SizedBox(
                height: 10,
              ),
              placemark != null
                  ? Visibility(
                      visible: placemark != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(placemark[0].subLocality),
                          Text(placemark[0].locality),
                          Text(placemark[0].administrativeArea),
                          Text(placemark[0].country),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
