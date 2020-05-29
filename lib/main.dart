import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Google Sample App',
        home: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
        backgroundColor: Colors.green[700],
      ),
      body: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

//  static final CameraPosition _kGooglePlex = CameraPosition(
//////    target: LatLng(-1.3828923, 36.6735812),
//////    zoom: 11.0,
//////  );

  static const LatLng _center = const LatLng(-1.3828923, 36.6735812);

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-0.3578866, 36.0874152994942),
      tilt: 20.440717697143555,
      zoom: 14.151926040649414);

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Random Place',
          snippet: '5 star Rating',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _currentMapType,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.map,
                      size: 36.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  FloatingActionButton(
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.add_location,
                      size: 36.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: _goToTheLake,
//        label: Text('To the Lake!'),
//        icon: Icon(Icons.directions_boat),
//      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
