import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/bloc/bloc.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  final _hostController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<SettingBloc, SettingState>(
        listener: (ctx, state) {
          if (state is SettingFailed) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(state.message),
              duration: Duration(seconds: 3),
            ));
          }
          if (state is SettingSuccess) {
            BlocProvider.of<AuthenticationBloc>(ctx).add(
              AuthenticationStarted(),
            );
          }
        },
        child: Container(
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
                        BlocProvider.of<SettingBloc>(context).add(
                          SettingSet(host: _hostController.text),
                        );
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
      ),
    );
  }
}
