import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/Homescreen/Homepage.dart';
import 'package:mero_kotha/authenthication/signinpage.dart';

class Introscreen extends StatefulWidget {
  const Introscreen({super.key});

  @override
  State<Introscreen> createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500), // slower transition
          pageBuilder: (context, animation, secondaryAnimation) => Signinpage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText(
              'Welcome to Room Finder',
              textStyle: TextStyle(fontSize: 22),
              duration: Duration(milliseconds: 1500), // longer = slower
            ),
          ],
          isRepeatingAnimation: false,
        ),
      ),
    );
  }
}

class IntroscreenafterLogin extends StatefulWidget {
  const IntroscreenafterLogin({super.key});

  @override
  State<IntroscreenafterLogin> createState() => _IntroscreenafterLoginState();
}

class _IntroscreenafterLoginState extends State<IntroscreenafterLogin> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500), // slower transition
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText(
              'Welcome to Room Finder',
              textStyle: TextStyle(fontSize: 22),
              duration: Duration(milliseconds: 1500), // longer = slower
            ),
          ],
          isRepeatingAnimation: false,
        ),
      ),
    );
  }
}
