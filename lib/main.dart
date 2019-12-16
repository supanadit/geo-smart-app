import 'package:flutter/material.dart';
import 'package:geo_app/page/startup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Smart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Startup(),
    );
  }
}
