import 'package:flutter/material.dart';

import 'src/routes/home.dart';
import 'src/routes/locator.dart';
import 'src/routes/points.dart';

void main() {
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