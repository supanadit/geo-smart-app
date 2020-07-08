import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geosmart/component/loader.dart';
import 'package:geosmart/page/map.dart';
import 'package:geosmart/page/setting.dart';
import 'package:geosmart/service/setting_service.dart';

class Startup extends StatefulWidget {
  @override
  State createState() {
    return new _StartupState();
  }
}

class _StartupState extends State<Startup> {
  SettingService _settingService;

  @override
  void initState() {
    _settingService = new SettingService();

    _settingService.getSetting().then((settingModel) {
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
    super.dispose();
  }
}
