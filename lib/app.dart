import 'package:flutter/material.dart';
import 'package:mediconnect/screens/Sign_in_screen.dart';
import 'package:mediconnect/screens/user_home_screen.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: signInScreen(),
    );
  }
}
