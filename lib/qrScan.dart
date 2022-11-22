import 'dart:async';
import 'dart:convert';
import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:conductor_app_flutter/tripSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_calling.dart';

class QrScan extends StatefulWidget {
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  bool _loading = false;
  String result = "Scan your QR code to Continue...";

  Future _scanQR() async {
    try {
      var result = await BarcodeScanner.scan();

      print(result.type); // The result type (barcode, cancelled, failed)
      print(result.rawContent); // The barcode content
      print(result.format); // The barcode format (as enum)
      print(result.formatNote); // If a unknown format was scanned this field contains a note
      print("-----------------------------------------------fazil printing");
      getVehicle(result.rawContent);
      // final prefs = await SharedPreferences.getInstance();
      // final String? vehicleDetail = prefs.getString('vehicle');
      // final String? tripDetail = prefs.getString('trips');
      // var vehicleDetails = json.decode(vehicleDetail!);
      // var tripDetails = json.decode(tripDetail!);
      //
      // print('----------------------------------------${vehicleDetails}');
      // print('----------------------------------------${tripDetails}');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return TripSelection();
      }));

      // String qrResult = (await BarcodeScanner.scan()) as String;
      // setState(() {
      //   _loading = true;
      //   if (qrResult != "") {
      //     result = qrResult;
      //     // print("-----------------------------------------------fazil printing");
      //     print("id" + result);
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return TripSelection();
      //     }));
      //   } else {
      //     result = "QR not Recognized";
      //     // print("-----------------------------------------------fazil printing");
      //   }
      // });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          _loading = false;
          result = "Camera permission was denied";
        });
        // print("-----------------------------------------------fazil printing");
      } else {
        setState(() {
          _loading = false;
          result = "Unknown Error $ex";
        });
        // print("-----------------------------------------------fazil printing");
      }
    } on FormatException {
      setState(() {
        _loading = false;
        result = "You pressed the back button before scanning anything";
      });
      // print("-----------------------------------------------fazil printing");
    } catch (ex) {
      setState(() {
        _loading = false;
        result = "Unknown Error $ex";
      });
      print("-----------------------------------------------fazil printing");
      print("-----------------------------------------------${ex.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(
        child: SpinKitFadingCircle(
          color: Color(0xfffed32f),
          // color: Colors.blue,
        ),
      )
          : Container(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}