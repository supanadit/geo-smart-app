import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_app/bloc/setting.dart';
import 'package:geo_app/bloc/unique_id_bloc.dart';
import 'package:geo_app/model/setting.dart';
import 'package:geo_app/page/map.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingState();
  }
}

class _SettingState extends State<Setting> {
  final _hostController = TextEditingController();
  SettingBloc _settingBloc;
  UniqueIDBloc _uniqueIDBloc;
  String id;
  String host;

  @override
  void initState() {
    _settingBloc = new SettingBloc();

    _settingBloc.getSetting();

    _settingBloc.subject.listen((settingModel) {
      this.id = settingModel.id;
      this.host = settingModel.host;

      _hostController.text = this.host;

      if (this.host != null && this.host != "") {
        _uniqueIDBloc = new UniqueIDBloc(settingModel);
        _uniqueIDBloc.getUniqueID();
      }

      if (_uniqueIDBloc != null) {
        this._uniqueIDBloc.subject.listen((uniqueId) {
          if (uniqueId.id != null && uniqueId.id != "") {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => Map(),
            ));
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/server.png"),
                    ),
                  ),
                  height: 200,
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: this._hostController,
                  decoration: InputDecoration(
                    labelText: "Host",
                    border: OutlineInputBorder(),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    this._settingBloc.setSetting(
                          new SettingModel(this._hostController.text),
                        );
                  },
                  child: Text("Save"),
                )
              ],
            ),
            width: 200,
            height: 400,
          ),
        ),
      ),
    );
  }
}
