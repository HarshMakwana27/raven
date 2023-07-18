import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raven/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: EdgeInsets.all(height / 14),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/raven.png',
                width: 150,
              ),
              SizedBox(
                height: height / 3,
              ),
              const Text(
                'Raven',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
