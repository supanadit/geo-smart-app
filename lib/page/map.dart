import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:geo_app/bloc/position_bloc.dart';
import 'package:geo_app/bloc/setting.dart';
import 'package:geo_app/model/position.dart';
import 'package:geo_app/page/setting.dart';
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
  Position _position;
  PositionBloc _positionBloc;
  SettingBloc _settingBloc;

  String id;
  String host;

  bool isGranted = false;
  bool isTracking = false;

  @override
  void initState() {
    super.initState();
    BackgroundLocation.checkPermissions();
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
    _settingBloc = new SettingBloc();

    _settingBloc.getSetting();

    _settingBloc.subject.listen((settingModel) {
      this.id = settingModel.id;
      this.host = settingModel.host;

      if (settingModel.isNullId()) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => Setting(),
        ));
      }

      if (this.host != null && this.host != "") {
        setState(() {
          _positionBloc = new PositionBloc(settingModel);
        });
      }
    });

    BackgroundLocation.getLocationUpdates((location) async {
      if (!isTracking) {
        this.isTracking = true;
      }
      if (!isGranted) {
        this.isGranted = true;
      }
      print("Location Updated");
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
        BackgroundLocation.stopLocationService();
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => Setting(),
        ));
      }

      if (this._position != null) {
        if (this._position.isValid()) {
          print("Valid Position");
          if (_positionBloc != null) {
            print("Send Position " +
                this._position.lat.toString() +
                ", " +
                this._position.lng.toString());
            _positionBloc.sendPosition(
              this._position.lat.toString(),
              this._position.lng.toString(),
            );
          }
        } else {
          print("Invalid Position");
        }
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
                (isTracking) ? "Stop Tracking" : "Start Tracking",
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
    if (isGranted) {
      if (isTracking) {
        BackgroundLocation.stopLocationService();
      } else {
        BackgroundLocation.startLocationService();
      }
      setState(() {
        isTracking = !isTracking;
      });
    } else {
      print("Access Denied");
    }
  }

  @override
  void dispose() {
    print("Disposed");
    super.dispose();
    BackgroundLocation.stopLocationService();
  }
}
