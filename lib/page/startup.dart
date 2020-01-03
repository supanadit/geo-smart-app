import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_app/bloc/setting.dart';
import 'package:geo_app/component/loader.dart';
import 'package:geo_app/page/map.dart';
import 'package:geo_app/page/setting.dart';

class Startup extends StatefulWidget {
  @override
  State createState() {
    return new _StartupState();
  }
}

class _StartupState extends State<Startup> {
  SettingBloc _settingBloc;

  @override
  void initState() {
    _settingBloc = new SettingBloc();

    _settingBloc.getSetting();

    _settingBloc.subject.listen((settingModel) {
      if (settingModel.isNullHost() && settingModel.isNullId()) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => Setting(),
        ));
      } else {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => Map(),
        ));
      }
    });

    super.initState();
  }

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

  @override
  void dispose() {
    _settingBloc.dispose();
    super.dispose();
  }
}
