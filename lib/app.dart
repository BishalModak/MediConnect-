import 'package:flutter/material.dart';
import 'package:mediconnect/screens/Sign_in_screen.dart';
import 'package:mediconnect/screens/call_ambulance/infoHandler/app_info.dart';
import 'package:mediconnect/screens/splash_screen.dart';
import 'package:mediconnect/screens/user_home_screen.dart';
import 'package:provider/provider.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
