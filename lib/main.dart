import 'package:flutter/material.dart';
import 'package:bloc/layout/home_layout.dart';
// import 'package:bloc/modules/bmi/bmi_screen.dart';
// import 'package:bloc/modules/counter/counter_screen.dart';
// import 'package:bloc/modules/login/login_screen.dart';
// import 'package:bloc/modules/messenger/messenger_screen.dart';
// import 'package:bloc/modules/users/users_screen.dart';

void main()
{
  runApp( MyApp());
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // constructor
  // build

  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}