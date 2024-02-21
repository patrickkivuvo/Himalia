import 'package:flutter/material.dart';
import 'dart:async';

import 'package:himalia/screens/authentication/auth_screen.dart';
import 'package:himalia/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation _logoAnimation;
  late AnimationController _logoController;

  @override
  void initState() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _logoAnimation.addListener(() {
      if (_logoAnimation.status == AnimationStatus.completed) {
        return;
      }
      setState(() {});
    });

    _logoController.forward();
    super.initState();
    startTime();
  }

  navigationPage() async {
    sharedPref = await SharedPreferences.getInstance();
    String userMap = sharedPref.getString('access_token') ?? "";
    if (userMap.isNotEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthenticationScreen()));
    }
  }

  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Image.asset(
              'assets/himalia_logo.png',
              height: 300,
              width: 300,
            ),
          ),
        ));
  }
}
