import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

import 'src/routes/home.dart';
import 'src/routes/locator.dart';
import 'src/routes/points.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/points': (context) => const Points(),
        '/locator': (context) => const Locator(),
      },
    ),
  );
}