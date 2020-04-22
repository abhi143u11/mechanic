import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _polylineCount = 1;
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  GoogleMapPolyline _googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyCI1CnwwhihO0XE8anMU3GX1UxDv-bZxzo");

  LatLng _mapInitLocation = LatLng(40.683337, -73.940432);

  LatLng _originLocation = LatLng(40.677939, -73.941755);
  LatLng _destinationLocation = LatLng(40.698432, -73.924038);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  bool _loading = false;

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.red,
        points: _coordinates,
        width: 10,
        onTap: () {});
    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  //Get polyline with Address
  _getPolylinesWithAddress() async {
    _setLoadingMenu(true);
    List<LatLng> _coordinates =
        await _googleMapPolyline.getPolylineCoordinatesWithAddress(
            origin: '55 Kingston Ave Brooklyn NY 11213',
            destination: '8007 Cypress Ave Glendale NY 11385',
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  //Get polyline with Location (latitude and longitude)
  _getPolylinesWithLocation() async {
    _setLoadingMenu(true);
    List<LatLng> _coordinates =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: _originLocation,
            destination: _destinationLocation,
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    print(_coordinates);
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  _setLoadingMenu(bool _status) {
    setState(() {
      _loading = _status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Location'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        polylines: Set<Polyline>.of(_polylines.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getPolylinesWithLocation,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
