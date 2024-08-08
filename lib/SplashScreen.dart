import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:mknews/Home.dart';
import 'package:mknews/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mknews/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    User? user=_auth.currentUser;
    return AnimatedSplashScreen(
      splash: Image.asset("images/logo.png"),
      nextScreen: user==null?const Login():const Home(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      duration: 100
    );
  }
}
