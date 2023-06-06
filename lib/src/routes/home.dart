
import 'package:flutter/material.dart';

import '../components/navbar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frog Hunter'),
      ),
      drawer: const NavBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('../assets/images/logo.png'),
              width: 300,
            ),
            SizedBox(
              height: 50,
            )
          ]
        ),
      ),
    );
  }
}