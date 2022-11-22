import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:conductor_app_flutter/connection.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

conductorLogin(userName, passWord) async {
  Map _loginBody = {
    "action": "login",
    "username": userName,
    "password": passWord
  };
  var _loginHeaders = {
    "Content-Type": "application/json",
    "API-KEY": "525-777-777"
  };
  var response = await http.post(Uri.parse(Constants.appURL),
      body: json.encode(_loginBody), headers: _loginHeaders);
  var conductor = response.body;
  var conductorLogin = json.decode(conductor);
  if (conductorLogin['data'] != null) {
    if (conductorLogin['data']['data'] == false) {
      print('------------------------Invalid Mobile number / Password');
    } else {
      if (conductorLogin['data']['data'] != null) {
        print('------------------------${conductorLogin['data']['data']['Emp_Name']}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('conductor', conductorLogin['data']['data']['Emp_Name'].toString());
      } else {
        print('------------------------Please Fill the fields');
      }
    }
  } else {
    print('------------------------conductor value of data is null');
  }

  // await prefs.remove('conductor');
  // final String? conductordetails = prefs.getString('conductor');
  // var conductorDetails = json.decode(conductordetails!);
  // //
  // if (conductorDetails != null) {
  //   print('-----------------------------------${conductorDetails}');
  // } else {
  //   print('-----------------------------------Error');
  // }
  // print('-----------------------------------${conductorDetails}');
}

getVehicle(vehicleID) async {
  final prefs = await SharedPreferences.getInstance();
  final String? conductordetails = prefs.getString('conductor');
  var conductorDetails = json.decode(conductordetails!);
  print('----------------------------------------$conductorDetails');
  // var instID = conductordetails['data']['data']['Inst_id'];

  Map _vehicleBody = {
    "action": "get_vehicle",
    "vehicleNum": "",
    "id": vehicleID
  };
  var _vehicleHeaders = {
    "Content-Type": "application/json",
    "API-KEY": "525-777-777"
  };
  var vehicleResponse = await http.post(Uri.parse(Constants.appURL),
      body: json.encode(_vehicleBody), headers: _vehicleHeaders);
  var vehicle = vehicleResponse.body;

  var _tripBody = {"action": "get_trips", "inst_id": "4", "vehicle_id": vehicleID};
  var tripResponse = await http.post(Uri.parse(Constants.appURL),
      body: json.encode(_tripBody), headers: _vehicleHeaders);
  var trips = tripResponse.body;

  await prefs.setString('vehicle', json.encode(vehicle));
  await prefs.setString('trips', json.encode(trips));

  // final String? vehicleDetail = prefs.getString('vehicle');
  // final String? tripDetail = prefs.getString('trips');
  // var vehicleDetails = json.decode(vehicleDetail!);
  // var tripDetails = json.decode(tripDetail!);
  //
  // print('----------------------------------------${vehicleDetails}');
  // print('----------------------------------------${tripDetails}');
}
