import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geosmart/config.dart';
import 'package:geosmart/model/setting.dart';
import 'package:geosmart/page/map.dart';
import 'package:geosmart/service/setting_service.dart';
import 'package:geosmart/service/unique_id_service.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingState();
  }
}

class _SettingState extends State<Setting> {
  final _hostController = TextEditingController();
  SettingService _settingBloc;
  UniqueIDService _uniqueIDBloc;
  String id;
  String host;

  @override
  void initState() {
    _settingBloc = new SettingService();

    if (!Config.dynamicHostSetting) {
      _settingBloc.setSetting(new SettingModel(Config.api, null));
    }

    _settingBloc.getSetting().then((settingModel) {
      if (!settingModel.isNullId()) {
        this.id = settingModel.id;
      }
      if (!settingModel.isNullHost()) {
        this.host = settingModel.host;
      }

      _hostController.text = this.host;

      if (!settingModel.isNullHost()) {
        _uniqueIDBloc = new UniqueIDService(settingModel);

        if (_uniqueIDBloc != null) {
          this._uniqueIDBloc.getUniqueID().then((uniqueId) {
            print("Your Unique ID " + uniqueId.id.toString());
            if (uniqueId.id != null && uniqueId.id != "") {
              if (!settingModel.isNullId()) {
                mapPage();
              } else {
                this._settingBloc.setSetting(
                      new SettingModel(this._hostController.text, uniqueId.id),
                    );
                mapPage();
              }
            } else {
              FlutterToast.showToast(msg: "Invalid host address");
            }
          });
        }
      }
    });
    super.initState();
  }

  mapPage() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) => Map(),
    ));
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
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      this
                          ._settingBloc
                          .setSetting(
                            new SettingModel(this._hostController.text, null),
                          )
                          .then((settingModel) {
                        if (!settingModel.isNullId()) {
                          this.id = settingModel.id;
                        }
                        if (!settingModel.isNullHost()) {
                          this.host = settingModel.host;
                        }

                        _hostController.text = this.host;

                        if (!settingModel.isNullHost()) {
                          _uniqueIDBloc = new UniqueIDService(settingModel);

                          if (_uniqueIDBloc != null) {
                            this._uniqueIDBloc.getUniqueID().then((uniqueId) {
                              print("Your Unique ID " + uniqueId.id.toString());
                              if (uniqueId.id != null && uniqueId.id != "") {
                                if (!settingModel.isNullId()) {
                                  mapPage();
                                } else {
                                  this._settingBloc.setSetting(
                                        new SettingModel(
                                          this._hostController.text,
                                          uniqueId.id,
                                        ),
                                      );
                                  mapPage();
                                }
                              } else {
                                FlutterToast.showToast(
                                  msg: "Invalid host address",
                                );
                              }
                            });
                          }
                        }
                      });
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
