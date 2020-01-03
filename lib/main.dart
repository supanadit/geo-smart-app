import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_app/page/startup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Geo Smart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Startup(),
    );
  }
}
