import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geosmart/model/position.dart';
import 'package:geosmart/model/setting.dart';
import 'package:geosmart/page/setting.dart';
import 'package:geosmart/service/position_service.dart';
import 'package:geosmart/service/setting_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  PositionService _positionService;
  SettingService _settingService;
  bool isChecking = true;
  Position _position;

  String id;
  String host;

  bool isGranted = false;
  bool isTracking = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isChecking = true;
    });
    _settingService = new SettingService();
    _positionService = new PositionService();
    // geo.Geolocator()..forceAndroidLocationManager = true;
    geo.Geolocator().checkGeolocationPermissionStatus().then(
      (v) {
        setState(() {
          isGranted = true;
        });
        var geolocator = geo.Geolocator();
        var locationOptions = geo.LocationOptions(
          accuracy: geo.LocationAccuracy.high,
        );

        geolocator
            .getPositionStream(locationOptions)
            .listen((geo.Position position) {
          if (this.id != null) {
            setState(() {
              this._position = Position(
                id: this.id,
                lat: position.latitude.toString(),
                lng: position.longitude.toString(),
                type: "user",
              );
            });
          } else {
            stopLocationService();
            settingPage();
          }
          print(
              "New position detected with lat ${position.latitude} and lng ${position.longitude}");
          sendLastPosition();
        });

        _settingService.getSetting().then((v) {
          this.id = v.id;
          this.host = v.host;

          if (v.isNullId()) {
            settingPage();
          }
        });
      },
    ).catchError((e) {
      setState(() {
        isGranted = false;
      });
    }).whenComplete(() {
      setState(() {
        isChecking = false;
      });
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
                    ? "Please wait"
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

  toggleTracking() {
    if (!isChecking) {
      if (isGranted) {
        if (isTracking) {
          stopLocationService();
        } else {
          sendLastPosition();
        }
        setState(() {
          isTracking = !isTracking;
        });
      } else {
        FlutterToast.showToast(
          msg: "Make sure you have turn on location services",
        );
      }
    }
  }

  stopLocationService() {
    if (_positionService != null) {
      _positionService.stopTracking();
    }
  }

  settingPage() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) => Setting(),
    ));
  }

  sendLastPosition() async {
    SettingModel m = await _settingService.getSetting();
    print("Prepare to Send last location with ID : ${m.id} to ${m.host}");
    if (this._position != null) {
      if (this._position.isValid()) {
        if (_positionService != null) {
          print("Lat ${_position.lat}, Lng ${_position.lng}");
          if (isTracking) {
            print("Send tracking location");
            _positionService.sendPosition(
              this._position.lat.toString(),
              this._position.lng.toString(),
            );
          }
        } else {
          FlutterToast.showToast(
            msg: "Failed to start position service",
          );
          settingPage();
        }
      } else {
        print("Invalid Position");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopLocationService();
  }
}
