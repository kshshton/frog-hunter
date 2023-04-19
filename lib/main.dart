import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/src/scrape/frog_scan.dart';
import 'package:location/location.dart';
import 'src/models/frog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Frog Hunter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, Marker> _markers = {};
  final Set<Circle> _radius = {};
  final List _blackList = [];
  final double _radiusDistance = 1000;
  LocationData? _currentLocation;
  FrogScan? _scan;

  _MyHomePageState() {
    _scan = FrogScan(3000);
  }

  void getCurrentLocation(GoogleMapController controller) async {
      Location location = Location();
      location.getLocation().then((location) {
          _currentLocation = location;
        },
      );
      location.onLocationChanged.listen((newLoc) {
        _currentLocation = newLoc;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 15,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  Future<void> scanLocation() async {
    final scan = await _scan?.getResponse();
    setState(() {
      for (final hit in scan?['hits']) {
        final frog = Frog.fromHit(hit);
        if (frog.status == "CLOSED") {
          final coords = LatLng(frog.lat, frog.lng);
          final identity = MarkerId(frog.id);
          final marker = Marker(
            markerId: identity,
            position: coords,
          );
          if (!_blackList.contains(marker.position)) {
            _markers[frog.address] = marker;
          }
        }
      }
    });
  }

  void huntDown() async {
    setState(() {
      _radius.add(
        Circle(
          circleId: const CircleId("radius"),
          center: LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ),
          radius: _radiusDistance,
          strokeWidth: 2,
          fillColor: const Color.fromARGB(80, 68, 68, 255)
        )
      );
      Timer(const Duration(seconds: 1), () {
        setState(() {
          _radius.clear();
          try {
            _markers.forEach((key, value) {
              if (distanceBetween(_currentLocation, value) < _radiusDistance) {
                _markers.remove(key);
                _blackList.add(value.position);
              }
            });
          } catch(_) {}
        });
      });
    });
  }

  double distanceBetween(currentLocation, marker){
    final lat1 = currentLocation.latitude;
    final lng1 = currentLocation.longitude;
    final lat2 = marker.position.latitude;
    final lng2 = marker.position.longitude;
    double point = 0.017453292519943295;
    double calc = 0.5 - cos((lat2 - lat1) * point)/2 + 
          cos(lat1 * point) * cos(lat2 * point) * 
          (1 - cos((lng2 - lng1) * point))/2;
    return 1000*(12742 * asin(sqrt(calc)));
  }

  @override
  void initState() {
    super.initState();
    scanLocation();
    _radius;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: GoogleMap(
        onMapCreated: getCurrentLocation,
        mapType: MapType.terrain,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: Set<Marker>.of(_markers.values),
        circles: Set<Circle>.of(_radius),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            FloatingActionButton(
              backgroundColor: const Color.fromARGB(100, 255, 255, 255),
              onPressed: scanLocation,
              tooltip: 'Scan Frogs',
              child: Image.asset(
                '../assets/images/scan.png',
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            FloatingActionButton(
              backgroundColor: const Color.fromARGB(100, 255, 255, 255),
              onPressed: huntDown,
              tooltip: 'Hunt Down',
              child: Image.asset(
                '../assets/images/logo.png',
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ]
        ),
      );
    }
  }