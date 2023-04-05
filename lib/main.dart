import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_in_flutter/src/frog_api.dart';
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
  FrogAPI? _api;
  final Map<String, Marker> _markers = {};

  _MyHomePageState() {
    _api = FrogAPI();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final response = await _api?.getResponse();
    setState(() {
      _markers.clear();
      for (final hit in response?['hits']) {
        var frog = Frog.fromHit(hit);
        if (frog.status == "CLOSED") {
          final coords = LatLng(frog.lat, frog.lng);
          final identity = MarkerId(frog.id);
          final marker = Marker(
            markerId: identity,
            position: coords,
          );
          _markers[frog.address] = marker;
          controller.animateCamera(CameraUpdate.newLatLngZoom(coords, 15));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          '../assets/images/logo.png',
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
