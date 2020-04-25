import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mechanic/providers/auth.dart';
import 'package:mechanic/providers/mechanic.dart';
import 'package:mechanic/screens/history.dart';
import 'package:mechanic/screens/reach_screen.dart';
import 'package:mechanic/screens/done_screen.dart';
import 'package:mechanic/screens/home_screen.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:mechanic/screens/map_screen.dart';
import 'package:mechanic/screens/setting.dart';
import 'package:mechanic/screens/signup_screen.dart';
import 'package:mechanic/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Mechanic>(
          update: (context, auth, prevMech) => Mechanic(auth.userId),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const String routeName = '/app';
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, _) => ChangeNotifierProvider(
        create:(context)=> Mechanic(auth.userId),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mechanic',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            SignupScreen.routeName: (context) => SignupScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            MapScreen.routeName: (context) => MapScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            ReachScreen.routeName: (context) => ReachScreen(),
            DoneScreen.routeName: (context) => DoneScreen(),
            MyApp.routeName: (context) => MyApp(),
            Setting.routeName: (context) => Setting(),
            History.routeName: (context) => History()
          },
        ),
      ),
    );
  }
}
