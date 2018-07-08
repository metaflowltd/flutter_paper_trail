import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_paper_trail/flutter_paper_trail.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    return FlutterPaperTrail.initLogger(
        hostName: "secret.papertrailapp.com",
        programName: "flutter-test-app",
        port: 9999,
        machineName: "Simulator(iPhone8)");
    //for machine name use Flutter DeviceInfoPlugin
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: () async {
            await FlutterPaperTrail.logError("I love logging errors on paper trail");
            await FlutterPaperTrail.logInfo("I love logging infos on paper trail");
            await FlutterPaperTrail.logWarning("I love logging warnings on paper trail");
            await FlutterPaperTrail.logDebug("I love logging debugs on paper trail");
          },
          tooltip: 'Log to papertrail',
          child: const Icon(Icons.add),
        ),
        appBar: new AppBar(
          title: const Text('Papertrail logging example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Press the + button to test logging to Papertrail'),
              RaisedButton(
                child: Text('Identify User'),
                onPressed: () {
                  FlutterPaperTrail.setUserId("JohnDeer391");
                },
              ),
              Text('Press the + button again after identifying the user'),
            ],
          ),
        ),
      ),
    );
  }
}
