import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:conductor_app_flutter/login.dart';
import 'package:conductor_app_flutter/tripSelection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'allstudents.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String? conductorName;

  getConductorDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final String? conductordetails = prefs.getString('conductor');
    print('conductor name-------$conductordetails');
    // var conductorDetails = json.decode(conductordetails!);
    // setState(() {
    //   conductorName = conductorDetails['data']['data']['Emp_Name'];
    // });
    // print('kkkdkk-----$conductorName');
  }

  getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    // final String? conductordetails = prefs.getString('conductor');
    // var conductorDetails = json.decode(conductordetails!);
    await prefs.remove('conductor');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  @override
  void initState() {
    getConductorDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Container(
            width: MediaQuery.of(context).size.width * .70,
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * .20,
                            decoration: BoxDecoration(
                                color: Color(0xffebfaf8),
                                border: Border.all(
                                    color: Color(0x24014840), width: 1),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12))),
                          ),
                        ],
                      ),
                      Container(
                        //vk
                        // alignment: Alignment.topCenter,
                        //end
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .12,
                          // vk
                          left: MediaQuery.of(context).size.height * .03,
                          //end
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffebfbf9),
                            border:
                                Border.all(color: Color(0xff2acbb9), width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              //old
                              // width: 165,
                              // height: 165,
                              //vk
                              width: 110,
                              height: 110,
                              //end
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/profilepic.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  ListTile(
                    //old
                    //title:Text(
                    //vk
                    title: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * .01),
                      //end
                      child: AutoSizeText(
                        'conductorName',
                        style: TextStyle(
                          fontFamily: 'Montserrat-Regular',
                          color: Color(0xff2acbb9),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    onTap: () => {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Profile(),
                      //   ),
                      // ),
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ListTile(
                    leading: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * .01),
                        child: Icon(Icons.home)),
                    title: AutoSizeText(
                      'Home',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      maxLines: 1,
                    ),
                    onTap: () => {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return TripSelection();
                      }))
                    },
                  ),
                  ListTile(
                    leading: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * .01),
                        child: Icon(Icons.phone_in_talk)),
                    title: AutoSizeText(
                      'Contact Manager',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      maxLines: 1,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * .01),
                        child: Icon(Icons.description)),
                    title: AutoSizeText(
                      'Reports',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      maxLines: 1,
                    ),
                    onTap: () => {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => TripReport(),
                      //   ),
                      // ),
                    },
                  ),
                  ListTile(
                    //old
                    //leading:Icon(Icons.home),
                    //vk
                    leading: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * .01),
                        child: Icon(Icons.lock_open)),
                    //end
                    title: AutoSizeText(
                      'Change Password',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      maxLines: 1,
                    ),
                    onTap: () => {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChangePassword(),
                      //   ),
                      // ),
                    },
                  ),
                  ListTile(
                    //old
                    //leading:Icon(Icons.home),
                    //vk
                    leading: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * .01),
                        child: Icon(Icons.people)),
                    //end
                    title: AutoSizeText(
                      'All Students',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      maxLines: 1,
                    ),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => allStudents(),
                        ),
                      ),
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xfffc5c66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Icon(
                          //   Icons.warning,
                          //   color: Colors.white,
                          // ),
                          FaIcon(
                            FontAwesomeIcons.exclamationTriangle,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          AutoSizeText(
                            "EMERGENCY",
                            style: TextStyle(
                              fontFamily: 'Montserrat-Regular',
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .09,
                  ),
                  ListTile(
                    //old
                    //leading:Icon(Icons.home),
                    //vk
                    leading: Container(
                        // alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * .01),
                        child: Icon(Icons.exit_to_app)),
                    //end
                    title: AutoSizeText(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                      maxLines: 1,
                    ),
                    onTap: () => {getDetails()},
                  ),
                ],
              ),
            ),
          );
        } else {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.all(2.0),
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .20,
                          decoration: BoxDecoration(
                            color: Color(0xffebfaf8),
                            border:
                                Border.all(color: Color(0x24014840), width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .15,
                        // right: 100.0,
                        // left: 100.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffebfbf9),
                          border:
                              Border.all(color: Color(0xff2acbb9), width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 215,
                            height: 215,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/profilepic.jpeg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                ListTile(
                  //old
                  //title:Text(
                  //vk
                  title: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * .01),
                    //end
                    child: Text(
                      'conductorName',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        color: Color(0xff2acbb9),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  onTap: () => {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Profile(),
                    //   ),
                    // ),
                  },
                ),
                SizedBox(
                  height: 45.0,
                ),
                // ListTile(
                //   leading: Icon(Icons.person),
                //   title: Text('Profile'),
                //   onTap: () => {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Profile(),
                //       ),
                //     ),
                //   },
                // ),
                ListTile(
                  //old
                  //leading:Icon(Icons.home),
                  //vk
                  leading: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * .01),
                      child: Icon(Icons.home)),
                  //end
                  title: Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 1,
                  ),
                  onTap: () => {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TripSelection(),
                    //   ),
                    // ),
                  },
                ),
                ListTile(
                  //old
                  //leading:Icon(Icons.home),
                  //vk
                  leading: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * .01),
                      child: Icon(Icons.phone_in_talk)),
                  //end
                  title: Text(
                    'Contact Manager',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 1,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * .01),
                      child: Icon(Icons.description)),
                  title: Text(
                    'Reports',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 1,
                  ),
                  onTap: () => {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TripReport(),
                    //   ),
                    // ),
                  },
                ),
                ListTile(
                  leading: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * .01),
                      child: Icon(Icons.lock_open)),
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 1,
                  ),
                  onTap: () => {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ChangePassword(),
                    //   ),
                    // ),
                  },
                ),
                ListTile(
                  leading: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * .01),
                      child: Icon(Icons.people)),
                  title: Text(
                    'All Students',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 1,
                  ),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => allStudents(),
                      ),
                    ),
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfffc5c66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Icon(
                        //   Icons.warning,
                        //   color: Colors.white,
                        // ),
                        FaIcon(
                          FontAwesomeIcons.hireAHelper,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          "EMERGENCY",
                          style: TextStyle(
                            fontFamily: 'Montserrat-Regular',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .09,
                ),
                ListTile(
                  //old
                  //leading:Icon(Icons.home),
                  //vk
                  leading: Container(
                      // alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * .01),
                      child: Icon(Icons.exit_to_app)),
                  //end
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 1,
                  ),
                  onTap: () => {
                    // _logout(),
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
