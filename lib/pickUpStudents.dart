import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:conductor_app_flutter/notifications.dart';
import 'package:conductor_app_flutter/showDialog.dart';
import 'package:conductor_app_flutter/tripSelection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:conductor_app_flutter/connection.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class pickUpStudents extends StatefulWidget {
  final String tripCode;
  final String startingPoint;
  final String endingPoint;
  final String startingTime;
  final String endingTime;
  final String vehicleNum;
  const pickUpStudents(
      {Key? key,
      required this.tripCode,
      required this.startingPoint,
      required this.endingPoint,
      required this.startingTime,
      required this.endingTime,
      required this.vehicleNum})
      : super(key: key);

  @override
  State<pickUpStudents> createState() => _pickUpStudentsState();
}

class _pickUpStudentsState extends State<pickUpStudents> {
  // TextEditingController textEditingController = TextEditingController();
  List<Map> studentName = [];
  List<Map> student_details = [];
  List<String> suggestons = [];
  late int i;
  late int d;
  late int f;
  var admNo;
  var students;
  var loader = false;
  bool boolean = false;
  String? studentNaMe;
  String? studentAdmNo;
  String? studentClass;
  var decodedStudents = [];

  // void clearText() {
  //   textEditingController.clear();
  // }

  getprefs() async {
    setState(() {
      loader = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String? studentApi = prefs.getString('studentApi');
    students = json.decode(studentApi!);
    for (i = 0; students['data'].length > i; i++) {
      setState(() {
        suggestons.add(students['data'][i]['Admn_No']);
      });
    }
    final String? allStudentsInBus = prefs.getString('studentsInBus');
    if (allStudentsInBus != null) {
      setState(() {
        decodedStudents = json.decode(allStudentsInBus);
      });
      if (decodedStudents.isNotEmpty) {
        for (f = 0; f < decodedStudents.length; f++) {
          studentName.insert(0, {
            "name": decodedStudents[f]['name'],
            "admissionNo": decodedStudents[f]['admissionNo']
          });
        }
      } else {
        print(decodedStudents);
      }
    } else {
      print('No students in bus');
    }
    setState(() {
      loader = false;
    });
  }

  stdDetails(selection) async {
    for (i = 0; i < students['data'].length; i++) {
      while (students['data'][i]['Admn_No'] == selection) {
        if (studentName.isNotEmpty) {
          for (d = 0; d < studentName.length; d++) {
            if (studentName[d]['admissionNo'] == selection) {
              setState(() {
                boolean = true;
              });
              break;
            } else {
              setState(() {
                boolean = false;
              });
            }
          }
          if (boolean == false) {
            studentName.insert(0, {
              "name": students['data'][i]['Student_name'],
              "admissionNo": students['data'][i]['Admn_No']
            });
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('studentsInBus', json.encode(studentName));
          } else {
            print('--------------------------------same 2 students');
          }
        } else {
          studentName.insert(0, {
            "name": students['data'][i]['Student_name'],
            "admissionNo": students['data'][i]['Admn_No']
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('studentsInBus', json.encode(studentName));
        }
        break;
      }
    }
  }

  studentDetails(selection) {
    for (i = 0; i < students['data'].length; i++) {
      if (students['data'][i]['Admn_No'] == selection) {
        setState(() {
          studentNaMe = students['data'][i]['Student_name'];
          studentAdmNo = students['data'][i]['Admn_No'];
          studentClass = students['data'][i]['Class'];
        });
        break;
      } else {
        // print('--------------------------------Else');
      }
    }
    // print('--------------------------------------Else');
  }

  remoVe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studentsInBus', json.encode(studentName));
  }

  // getAPI() async {
  //   setState(() {
  //     loader = true;
  //   });
  //   Map _passData = {"action": "getAllStudents", "inst_id": "4"};
  //   var response = await http.post(
  //     Uri.parse(Constants.studentURL),
  //     body: json.encode(_passData),
  //     headers: {"Content-Type": "application/json", "API-KEY": "525-777-777"},
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       loader = false;
  //     });
  //     students = json.decode(response.body);
  //
  //     // final prefs = await SharedPreferences.getInstance();
  //     // await prefs.setString('studentApi', json.encode(students));
  //   } else {
  //     setState(() {
  //       loader = false;
  //     });
  //     print(response.statusCode);
  //     throw Exception("Failed to Load your Data" + "${response.statusCode}");
  //   }
  // }

  _scanQr() async {
    var result = await BarcodeScanner.scan();

    print(result.type);
    print(result.rawContent);
    print(result.format);
    print(result.formatNote);
  }

  @override
  void initState() {
    super.initState();
    getprefs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: loader
              ? Center(
                  child: SpinKitFadingCircle(
                    color: Color(0xfffed32f),
                    // color: Colors.blue,
                  ),
                )
              : SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Autocomplete(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            } else {
                              List<String> matches = <String>[];
                              matches.addAll(suggestons);

                              matches.retainWhere((s) {
                                // return s.toLowerCase().contains(
                                //     textEditingValue.text.toLowerCase());
                                return s.toLowerCase().startsWith(
                                    textEditingValue.text.toLowerCase());
                              });

                              return matches;
                            }
                          },
                          onSelected: (String selection) {
                            setState(() {
                              print('claer');
                              //textEditingController.clear();
                            });
                            studentDetails(selection);
                            _showMyDialog(context, selection);
                            print('You just selected $selection');
                          },

                          // optionsViewBuilder: (context, onSelected, options) {},
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted) {
                            return Column(
                              children: [
                                TextField(
                                  keyboardType: TextInputType.datetime,
                                  textInputAction: TextInputAction.go,
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onSubmitted: (String value) {
                                    // _showMyDialog(context, value);
                                    // textEditingController.clear();
                                  },
                                  decoration: InputDecoration(
                                      // icon: Icon(Icons.search, color: Colors.black),
                                      // prefixIcon: Icon(Icons.search, color: Colors.black),
                                      hintText: 'Search students...',
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      border: InputBorder.none,
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            _scanQr();
                                          },
                                          child: Icon(
                                              Icons.qr_code_scanner_rounded,
                                              color: Colors.black)),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: Colors.black,
                                      )),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/tripPickPointsHead.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .06,
                                right: MediaQuery.of(context).size.width * .03,
                                left: MediaQuery.of(context).size.width * .03,
                              ),
                              child: Container(
                                height: 150.0,
                                decoration: BoxDecoration(
                                  color: Color(0xfffed32f),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x0f000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: AutoSizeText(
                                          widget.tripCode,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-Regular',
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      Container(
                                        // width: 174,
                                        // height: 43.678955078125,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .05,
                                        decoration: BoxDecoration(
                                          color: Color(0xfffed32f),
                                          border: Border.all(
                                              color: Color(0xff707070),
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                width: 25,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff707070),
                                                  border: Border.all(
                                                      color: Color(0xff707070),
                                                      width: 1.5),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                widget.vehicleNum,
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Montserrat-Regular',
                                                  color: Color(0xff616161),
                                                  // fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                width: 25,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff707070),
                                                  border: Border.all(
                                                      color: Color(0xff707070),
                                                      width: 1.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // startfrom here
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .16,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                      ),
                                      child: Container(
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xfffef3ca),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x26707070),
                                              offset: Offset(0, 3),
                                              blurRadius: 6,
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 130,
                                  // width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .26,
                                    right:
                                        MediaQuery.of(context).size.width * .03,
                                    left:
                                        MediaQuery.of(context).size.width * .03,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x0f000000),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            .04),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.radio_button_unchecked,
                                                  size: 15.0,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Container(
                                                  width: 185,
                                                  child: AutoSizeText(
                                                    widget.startingPoint,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            'Montserrat-Regular',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors.grey),
                                                    minFontSize: 12,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                AutoSizeText(
                                                  widget.startingTime,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily:
                                                          'Montserrat-Regular',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.grey),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 3,
                                              child: Divider(
                                                color: Colors.grey,
                                                indent: 30.0,
                                              ),
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .03,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .23,
                                              decoration: BoxDecoration(
                                                color: Color(0xff2acbb9),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: AutoSizeText(
                                                  widget.tripCode,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily:
                                                          'Montserrat-Regular',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.white),
                                                  maxFontSize: 12,
                                                  minFontSize: 8,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Divider(
                                                color: Colors.grey,
                                                endIndent: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.radio_button_unchecked,
                                                  size: 15.0,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Container(
                                                  width: 185,
                                                  child: AutoSizeText(
                                                    widget.endingPoint,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            'Montserrat-Regular',
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors.grey),
                                                    minFontSize: 10,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                AutoSizeText(
                                                  widget.endingTime,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily:
                                                          'Montserrat-Regular',
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.grey),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: 400,
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        .43,
                                    right:
                                        MediaQuery.of(context).size.width * .03,
                                    left:
                                        MediaQuery.of(context).size.width * .03,
                                  ),
                                  child: ListView.builder(
                                    reverse: false,
                                    itemCount: studentName.length,
                                    itemBuilder: (context, index) => Students(
                                        studentName[index]["name"],
                                        studentName[index]["admissionNo"],
                                        studentName[index]
                                        // studentName[index]["Student_name"].toString()
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            icon: Icon(Icons.airport_shuttle_rounded),
            label: Text("Stop"),
            onPressed: () {
              if (studentName.isEmpty) {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return TripSelection();
                }));
              }
            },
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  Students(name, admNo, index) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        // dismissible: DismissiblePane(onDismissed: () {
        //   setState(() {
        //     studentName.remove(index);
        //     remoVe();
        //   });
        // }),
        children: [
          Container(
              width: 92,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0f000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      setState(() {
                        studentName.remove(index);
                        remoVe();
                      });
                    });
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.red, size: 20),
                  label: Text(
                    'Drop',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )))
        ],
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(2.0),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: Container(
                        // constraints: const BoxConstraints(maxWidth: 200),
                        child: Container(
                          height: 70,
                          width: 315,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0f000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                CircleAvatar(),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15),
                                    Container(
                                      width: 250,
                                      padding: EdgeInsets.only(right: 13.0),
                                      child: Text(
                                        name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Color(0xFFB74093),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 250,
                                      padding: EdgeInsets.only(right: 13.0),
                                      child: Text(
                                        admNo,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(context, String selection) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // title: CircleAvatar(
          //   radius: 80,
          // ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'NAME : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB74093)),
                    ),
                    Container(
                        width: 200,
                        child: Text(
                          studentNaMe!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Color(0xFFB74093)),
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'ADMISSION NO : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB74093)),
                    ),
                    Text(
                      studentAdmNo!,
                      style: TextStyle(color: Color(0xFFB74093)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'CLASS : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB74093)),
                    ),
                    Text(
                      studentClass!,
                      style: TextStyle(color: Color(0xFFB74093)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.all(8),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      //textEditingController.clear();
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Take'),
                    onPressed: () {
                      setState(() {
                        //textEditingController.clear();
                        admNo = selection;
                      });
                      stdDetails(selection);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
