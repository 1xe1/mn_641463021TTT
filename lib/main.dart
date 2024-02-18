import 'package:flutter/material.dart';
import 'package:mn_641463021/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), //เรียกหน้า splash
    );
  }
}