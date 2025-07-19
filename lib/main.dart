import 'package:ctps_app/pages/homeScreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    // Simulate app loading for 3 secs (replace with your initialization logic)
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomeScreen(),

      //theme: ThemeData(primarySwatch: Colors.orange),
    );
    // home: ClientForm());
  }
}
