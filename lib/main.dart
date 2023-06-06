import 'package:flutter/material.dart';

import 'src/routes/home.dart';
import 'src/routes/locator.dart';
import 'src/routes/profile.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/locator': (context) => const Locator(),
        '/profile': (context) => const Profile()
      },
    ),
  );
}