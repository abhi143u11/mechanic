import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:mechanic/providers/auth.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _latitude;
  double _longitude;
  int _polylineCount = 1;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapPolyline _googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyCI1CnwwhihO0XE8anMU3GX1UxDv-bZxzo");
  LatLng _originLocation;
  LatLng _destinationLocation;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getLocation();
      List<double> data = ModalRoute.of(context).settings.arguments;
      print(data);
      _destinationLocation = LatLng(data[0], data[1]);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _originLocation = LatLng(28.669155, 77.453758);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Location'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(28.669155, 77.453758), zoom: 14),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('View'),
        onPressed: _userLocation,
      ),
    );
  }

  static final CameraPosition _user = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(28.669155, 77.453758),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _userLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_user));
  }


}
