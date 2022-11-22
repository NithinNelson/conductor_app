import 'dart:convert';
import 'package:conductor_app_flutter/pickUpStudents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:conductor_app_flutter/connection.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'navdrawer.dart';
import 'notifications.dart';

class TripSelection extends StatefulWidget {
  @override
  _TripSelectionState createState() => _TripSelectionState();
}

class _TripSelectionState extends State<TripSelection> {
  bool loader = false;
  var trips;
  late int i;

  getprefs() async {
    setState(() {
      loader = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String? allTrips = prefs.getString('allTrips');
    trips = json.decode(allTrips!);

    for (i = 0; i < trips['data']['data'].length; i++) {
      print(
          '==================================${trips['data']['data'][i]['tripName']}');
    }
    setState(() {
      loader = false;
    });
  }

  getAPI() async {
    setState(() {
      loader = true;
    });
    Map _passData = {
      "action": "get_trips",
      "inst_id": "4",
      "vehicle_id": "121"
    };
    var response = await http.post(
      Uri.parse(Constants.tripIDurl),
      body: json.encode(_passData),
      headers: {"Content-Type": "application/json", "API-KEY": "525-777-777"},
    );
    if (response.statusCode == 200) {
      trips = json.decode(response.body);

      // for (i = 0; i < trips['data']['data'].length; i++) {
      //   print(
      //       '==================================${trips['data']['data'][i]['tripName']}');
      // }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('allTrips', json.encode(trips));
    } else {
      setState(() {
        loader = false;
      });
      print(response.statusCode);
      throw Exception("Failed to Load your Data" + "${response.statusCode}");
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    getAPI();
    getprefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.transparent,
                //vk
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notifications(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              drawer: NavDrawer(),
              body: loader
                  ? Center(
                      child: SpinKitFadingCircle(
                        color: Color(0xfffed32f),
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .25,
                                    width: MediaQuery.of(context).size.width,
                                    child: SvgPicture.asset(
                                      "assets/Tab.svg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          .23,
                                      right: MediaQuery.of(context).size.width *
                                          .05,
                                      left: MediaQuery.of(context).size.width *
                                          .05,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xfffed32f),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
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
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30),
                                                    child: Text(
                                                      'Select Trip',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat-Regular',
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                // Container(
                                                //   height: 40.0,
                                                //   width: 40.0,
                                                //   child: ElevatedButton(
                                                //     onPressed: () {
                                                //       // Navigator.pushReplacement(
                                                //       //   context,
                                                //       //   MaterialPageRoute(
                                                //       //     builder: (context) =>
                                                //       //         TripSelectionMore(1),
                                                //       //   ),
                                                //       // );
                                                //     },
                                                //     child: Icon(
                                                //       Icons.arrow_forward_ios,
                                                //       color: Colors.white,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          // height: 300,
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .32,
                            right: MediaQuery.of(context).size.width * .05,
                            left: MediaQuery.of(context).size.width * .05,
                          ),
                          child: ListView.builder(
                            itemCount: trips['data']['data'].length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return pickUpStudents(
                                          tripCode: trips['data']['data'][index]
                                          ['tripName'],
                                          startingTime: trips['data']['data']
                                          [index]['startingpointtime'],
                                          endingPoint: trips['data']['data']
                                          [index]['endingpoint'],
                                          startingPoint: trips['data']['data']
                                          [index]['startingpoint'],
                                          endingTime: trips['data']['data']
                                          [index]['endingpointtime'],
                                          vehicleNum: trips['data']['data']
                                          [index]['vehicleNum'],
                                        );
                                      }));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons
                                                          .radio_button_unchecked,
                                                      size: 15.0,
                                                      color: Colors.green,
                                                    ),
                                                    SizedBox(
                                                      width: 15.0,
                                                    ),
                                                    Container(
                                                      width: 185,
                                                      child: Text(
                                                        trips['data']['data']
                                                                [index]
                                                            ['startingpoint'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                'Montserrat-Regular',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color: Colors.grey),
                                                        // minFontSize: 12,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      trips['data']['data']
                                                              [index]
                                                          ['startingpointtime'],
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
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      trips['data']['data']
                                                          [index]['tripName'],
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              'Montserrat-Regular',
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Colors.white),
                                                      // maxFontSize: 12,
                                                      // minFontSize: 8,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons
                                                          .radio_button_unchecked,
                                                      size: 15.0,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 15.0,
                                                    ),
                                                    Container(
                                                      width: 185,
                                                      child: Text(
                                                        trips['data']['data']
                                                                [index]
                                                            ['endingpoint'],
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                'Montserrat-Regular',
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color: Colors.grey),
                                                        // minFontSize: 10,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      trips['data']['data']
                                                              [index]
                                                          ['endingpointtime'],
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
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ));
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  "Transport+",
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications_none),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Notifications(),
                      ),
                    );
                  },
                ),
              ],
            ),
            drawer: NavDrawer(),
            body: loader
                ? Center(
                    child: SpinKitFadingCircle(
                      color: Color(0xfffed32f),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * .30,
                              width: MediaQuery.of(context).size.width,
                              // child: SvgPicture.asset(
                              //   "assets/images/Tab.svg",
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .28,
                            right: MediaQuery.of(context).size.width * .1,
                            left: MediaQuery.of(context).size.width * .1,
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
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'tripCode',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-Regular',
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 40.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         TripSelectionMore(1),
                                        //   ),
                                        // );
                                      },
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .34,
                            right: MediaQuery.of(context).size.width * .1,
                            left: MediaQuery.of(context).size.width * .1,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .16,
                            width: MediaQuery.of(context).size.width,
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
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.album,
                                            color: Colors.green,
                                          ),
                                          Text('source'),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text('sourceTime'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.album,
                                            color: Colors.red,
                                          ),
                                          Text('destination'),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text('destTime'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .56,
                            right: MediaQuery.of(context).size.width * .2,
                            left: MediaQuery.of(context).size.width * .2,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 165,
                              height: 65,
                              child: ElevatedButton(
                                onPressed: () {
                                  // pickupfordrop(tripId, tripCode, source,
                                  //     destination, sourceTime, destTime);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff26dd81),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  "Go",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-Regular',
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .75,
                            right: MediaQuery.of(context).size.width * .2,
                            left: MediaQuery.of(context).size.width * .2,
                          ),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            height: MediaQuery.of(context).size.height * .15,
                            width: MediaQuery.of(context).size.width * .75,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Contact Manager",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'Montserrat-Regular',
                                  color: Color(0xff7f8483),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }
      },
    );
  }
}
