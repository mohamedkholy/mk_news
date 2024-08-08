import 'package:flutter/material.dart';
import 'package:mknews/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mknews/firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return MyState();
  }
}

class MyState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: const AppBarTheme(color: Colors.white)),
      home: const SplashScreen(),
    );
  }
}
