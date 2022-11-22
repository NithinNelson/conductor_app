import 'dart:convert';
import 'package:conductor_app_flutter/showDialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:conductor_app_flutter/connection.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class allStudents extends StatefulWidget {
  const allStudents({Key? key}) : super(key: key);

  @override
  State<allStudents> createState() => _allStudentsState();
}

class _allStudentsState extends State<allStudents> {
  // List<String> suggestons = [];
  var students;
  // var studentList;
  // String? studentName;
  // List<Map> messsages = [];
  late int i;
  var loader = false;

  _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      getAPI();
    } else {
      getprefs();
    }
  }

  getprefs() async {
    setState(() {
      loader = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String? studentApi = prefs.getString('studentApi');
    setState(() {
      loader = false;
    });
    students = json.decode(studentApi!);
    // for (i = 0; studentList['data'].length > i; i++) {
    //   print(
    //       '==================================${studentList['data'][i]['Student_name']}');
    // }
  }

  getAPI() async {
    setState(() {
      loader = true;
    });
    // final prefs = await SharedPreferences.getInstance();
    // final String? conductordetails = prefs.getString('conductor');
    // var conductorDetails = json.decode(conductordetails!);

    Map _passData = {"action": "getAllStudents", "inst_id": "4"};
    var response = await http.post(
      Uri.parse(Constants.studentURL),
      body: json.encode(_passData),
      headers: {"Content-Type": "application/json", "API-KEY": "525-777-777"},
    );
    if (response.statusCode == 200) {
      setState(() {
        loader = false;
      });
      students = json.decode(response.body);

      // for (i = 0; students['data'].length > i; i++) {
      //   print(
      //       '==================================${students['data'][i]['Student_name']}');
      // }
      // for (i = 0; students['data'].length > i; i++) {
      //   // print(
      //   //     '==================================${students['data'][i]['Admn_No']}');
      //   setState(() {
      //     suggestons.add(students['data'][i]['Admn_No']);
      //   });
      // }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('studentApi', json.encode(students));
      // await prefs.setStringList('items', json.encode(suggestons));
    } else {
      setState(() {
        loader = false;
      });
      print(response.statusCode);
      throw Exception("Failed to Load your Data" + "${response.statusCode}");
    }
  }

  @override
  void initState() {
    _checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loader
            ? Center(
                child: SpinKitFadingCircle(
                  color: Color(0xfffed32f),
                  // color: Colors.blue,
                ),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: ListView.builder(
                  itemCount: students['data'].length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(students['data'][index]['Student_name']),
                        subtitle: Text(students['data'][index]['Admn_No']),
                        leading: CircleAvatar(),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
