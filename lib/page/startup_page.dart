import 'package:flutter/material.dart';
import 'package:geosmart/component/loader.dart';

class StartupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Loader(),
              SizedBox(
                height: 20.0,
              ),
              Text("Preparing System")
            ],
          ),
          height: 50,
        ),
      ),
    );
  }
}
