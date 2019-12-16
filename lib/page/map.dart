import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:geo_app/bloc/position_bloc.dart';
import 'package:geo_app/bloc/setting.dart';
import 'package:geo_app/model/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

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

  @override
  void initState() {
    BackgroundLocation.startLocationService();
    super.initState();
    _settingBloc = new SettingBloc();

    _settingBloc.getSetting();

    _settingBloc.subject.listen((settingModel) {
      this.id = settingModel.id;
      this.host = settingModel.host;

      if (this.host != null && this.host != "") {
        setState(() {
          _positionBloc = new PositionBloc(settingModel);
        });
      }
    });
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
    });
    bg.BackgroundGeolocation.ready(
      bg.Config(
          desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 10.0,
          stopOnTerminate: false,
          startOnBoot: true,
          debug: true,
          logLevel: bg.Config.LOG_LEVEL_VERBOSE),
    ).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
    BackgroundLocation.getLocationUpdates((location) async {
      print("Location Update");
      setState(() {
        this.latitude = location.latitude;
        this.longitude = location.longitude;
        this.accuracy = location.accuracy;
        this.altitude = location.altitude;
        this.bearing = location.bearing;
        this.speed = location.speed;

        if (this._position != null) {
          if (this._position.isValid()) {
            print("VALID");
            if (_positionBloc != null) {
              print("SEND");
              _positionBloc.sendPosition(
                this._position.lat.toString(),
                this._position.lng.toString(),
              );
            }
          }
        }
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
              print("Map Created");
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }
}
