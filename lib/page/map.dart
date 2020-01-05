import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geo_app/bloc/position_bloc.dart';
import 'package:geo_app/bloc/setting.dart';
import 'package:geo_app/model/position.dart';
import 'package:geo_app/page/setting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class Map extends StatefulWidget {
  Map({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  double latitude = 0.0;
  double longitude = 0.0;
  double altitude = 0.0;
  double accuracy = 0.0;
  double bearing = 0.0;
  double speed = 0.0;
  Position _position;
  PositionBloc _positionBloc;
  SettingBloc _settingBloc;
  PublishSubject<bool> _checkDevice;
  bool isChecking = true;

  String id;
  String host;

  bool isGranted = false;
  bool isTracking = false;
  int androidSDKVersion = 0;

  _MapState() {
    _checkDevice = PublishSubject<bool>();
  }

  getPermission() {
    BackgroundLocation.getPermissions(
      onDenied: () {
        isGranted = false;
        print("Denied");
      },
      onGranted: () {
        isGranted = true;
        print("Granted");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    PermissionHandler()
        .requestPermissions([PermissionGroup.location]).then((permissions) {
      permissions.forEach((group, status) {
        print("$group With Status $status");
      });
    });
    if (Platform.isAndroid) {
      PermissionHandler()
          .shouldShowRequestPermissionRationale(PermissionGroup.location)
          .then((isShow) {
        print("Is Show $isShow");
      });
      DeviceInfoPlugin().androidInfo.then((androidInfo) {
        var release = androidInfo.version.release;
        var sdkInt = androidInfo.version.sdkInt;
        var manufacturer = androidInfo.manufacturer;
        var model = androidInfo.model;
        print('Android $release (SDK $sdkInt), $manufacturer $model');
        androidSDKVersion = sdkInt;
        if (sdkInt > 21) {
          getPermission();
          BackgroundLocation.getLocationUpdates((location) async {
            print("Location Updated");
            if (!isTracking) {
              this.isTracking = true;
            }
            if (!isGranted) {
              this.isGranted = true;
            }
            this.latitude = location.latitude;
            this.longitude = location.longitude;
            this.accuracy = location.accuracy;
            this.altitude = location.altitude;
            this.bearing = location.bearing;
            this.speed = location.speed;

            if (this.id != null) {
              this._position = Position(
                id: this.id,
                lat: this.latitude.toString(),
                lng: this.longitude.toString(),
                type: "user",
              );
            } else {
              stopLocationService();
              settingPage();
            }

            if (this._position != null) {
              if (this._position.isValid()) {
                if (_positionBloc != null) {
                  _positionBloc.sendPosition(
                    this._position.lat.toString(),
                    this._position.lng.toString(),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Failed to start position service",
                  );
                  settingPage();
                }
              } else {
                print("Invalid Position");
              }
            }
            setState(() {
              isChecking = false;
            });
          });
        }
        if (sdkInt <= 21) {
          bg.BackgroundGeolocation.onLocation((bg.Location location) {
            print('[location] - $location');
          });

          bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
            print('[motionchange] - $location');
          });

          bg.BackgroundGeolocation.onProviderChange(
              (bg.ProviderChangeEvent event) {
            print('[providerchange] - $event');
          });

          bg.BackgroundGeolocation.ready(
            bg.Config(
              desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
              distanceFilter: 10.0,
              stopOnTerminate: false,
              startOnBoot: true,
              debug: true,
              logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            ),
          ).then(
            (bg.State state) {
              if (!state.enabled) {
                isGranted = true;
                isChecking = false;
              }
            },
          );
        }
      });
    } else {
      getPermission();
      setState(() {
        isChecking = false;
      });
    }

    _settingBloc = new SettingBloc();

    _settingBloc.getSetting();

    _settingBloc.subject.listen((settingModel) {
      this.id = settingModel.id;
      this.host = settingModel.host;

      if (settingModel.isNullId()) {
        settingPage();
      }

      if (this.host != null && this.host != "") {
        setState(() {
          _positionBloc = new PositionBloc(settingModel);
          _positionBloc.subject.listen((position) {
            if (position.isError()) {
              stopLocationService();
              settingPage();
            }
          });
        });
      }
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.914744, 107.609810),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            child: Image.asset("assets/images/logo.png"),
            width: 70,
            height: 70,
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 10.0),
          ),
          Container(
            child: FlatButton(
              color: (isTracking) ? Colors.redAccent : Colors.green,
              onPressed: toggleTracking,
              child: Text(
                (isChecking)
                    ? "Pleasewait"
                    : ((isTracking) ? "Stop Tracking" : "Start Tracking"),
                style: TextStyle(color: Colors.white),
              ),
            ),
            margin: EdgeInsets.only(bottom: 50.0),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }

  stopLocationService() {
    if (androidSDKVersion > 21 || !Platform.isAndroid) {
      BackgroundLocation.stopLocationService();
    }
    if (androidSDKVersion <= 21) {
      bg.BackgroundGeolocation.stop();
    }
    if (_positionBloc != null) {
      _positionBloc.stopTracking();
    }
  }

  startLocationService() {
    if (androidSDKVersion > 21 || !Platform.isAndroid) {
      BackgroundLocation.startLocationService();
    }
    if (androidSDKVersion <= 21) {
      bg.BackgroundGeolocation.start();
    }
  }

  toggleTracking() {
    if (!isChecking) {
      if (isGranted) {
        if (isTracking) {
          stopLocationService();
        } else {
          startLocationService();
        }
        setState(() {
          isTracking = !isTracking;
        });
      } else {
        Fluttertoast.showToast(
          msg: "Make sure you have turn on location services",
        );
      }
    }
  }

  settingPage() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) => Setting(),
    ));
  }

  @override
  void dispose() {
    print("Disposed");
    super.dispose();
    stopLocationService();
  }
}
