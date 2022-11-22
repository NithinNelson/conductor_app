import 'dart:async';
import 'dart:convert';
import 'package:conductor_app_flutter/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './qrScan.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      // final prefs = await SharedPreferences.getInstance();
      // final String? conductordetails = prefs.getString('conductor');
      // var conductorDetails = json.decode(conductordetails!);
      // if (conductorDetails != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return QrScan();
      }));
      //   } else {
      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      //       return Login();
      //     }));
      //   }
      //   print('----------------------------$conductorDetails');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // seconds: 2,
      // navigateAfterSeconds: new navigationpage(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DocmeTransport',
              textScaleFactor: 2,
            ),
            SizedBox(height: 200),
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text("Loading"),
          ],
        ),
      ),
    );
  }
}
