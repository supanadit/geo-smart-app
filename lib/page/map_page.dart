import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:geosmart/bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  bool isChecking = true;
  bool isGranted = false;
  bool isTracking = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isChecking = true;
    });
    Geolocator.checkPermission().then((value) {
      setState(() {
        if (value != LocationPermission.deniedForever) {
          setState(() {
            isChecking = false;
            isGranted = true;
          });
        }
      });
    });
    Geolocator.getPositionStream().listen((Position position) {
      if (isTracking && isGranted) {
        BlocProvider.of<PositionBloc>(context).add(
          PositionSend(
            lat: position.latitude.toString(),
            lng: position.longitude.toString(),
          ),
        );
      }
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.914744, 107.609810),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PositionBloc, PositionState>(
        listener: (ctx, state) {
          if (state is PositionTrackingFailed) {
            BlocProvider.of<AuthenticationBloc>(ctx).add(
              AuthenticationClear(),
            );
          }
          if (state is PositionTrackingStarted) {
            isTracking = true;
          }
          if (state is PositionTrackingIdle) {
            isTracking = false;
          }
        },
        child: BlocBuilder<PositionBloc, PositionState>(
          builder: (ctx, state) {
            return Stack(
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
                    color: (state is PositionTrackingStarted)
                        ? Colors.redAccent
                        : Colors.green,
                    onPressed: () async {
                      if (state is PositionTrackingStarted) {
                        BlocProvider.of<PositionBloc>(ctx).add(
                          PositionStopTracking(),
                        );
                      }
                      if (state is PositionTrackingIdle) {
                        BlocProvider.of<PositionBloc>(ctx).add(
                          PositionStartTracking(),
                        );
                      }
                    },
                    child: Text(
                      (isChecking)
                          ? "Please wait"
                          : (state is PositionTrackingStarted
                              ? "Stop Tracking"
                              : "Start Tracking"),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 50.0),
                  alignment: Alignment.bottomCenter,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
