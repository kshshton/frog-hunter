import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/src/frog_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frog Hunter',
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
  dynamic _response;

  _MyHomePageState() {
    _api = FrogAPI();
  }

  void _huntDown() async {
    var response = await _api?.getResponse()
      .then((json) => json['hits'][0]);
    setState(() {
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frog hunter"),
      ),
      body: Center(
        child: _response != null ? Text('Frog location: ${_response['_geoloc']?.toString()}') : const Text(''),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _huntDown,
        tooltip: 'Hunt down',
        child: const Icon(Icons.add),
      ),
    );
  }
}