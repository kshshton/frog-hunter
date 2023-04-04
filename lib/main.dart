import 'package:flutter/material.dart';
import 'package:google_maps_in_flutter/src/frog_api.dart';
import 'src/models/model_frog.dart';

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
  Frog? _frog;

  _MyHomePageState() {
    _api = FrogAPI();
  }

  void _huntDown() async {
    var response = await _api?.getResponse();
    setState(() {
      for (final hit in response?['hits']) {
        var frog = Frog.fromHit(hit);
        if (frog.status == "CLOSED") {
          _frog = frog;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Frog hunter"),
      ),
      body: Center(
        child: _frog != null ? Text(
            'Frog location: ${_frog?.coords}'
          ) : const Text(''),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _huntDown,
        tooltip: 'Hunt down',
        child: const Icon(Icons.add),
      ),
    );
  }
}