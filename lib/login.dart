import 'package:conductor_app_flutter/qrScan.dart';
import 'package:conductor_app_flutter/showDialog.dart';
import 'package:conductor_app_flutter/tripSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:conductor_app_flutter/connection.dart' as Constants;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_calling.dart';
// import './trip_selection.dart';
// import '../widgets/notifications.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../widgets/newQrScan.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Connection conn = new Connection();

  bool _loading = false;
  bool _showPassword = true;
  String? mobile;
  TextEditingController _phoneNumText = TextEditingController();

  TextEditingController _securityPin = TextEditingController();

  final FocusNode _phoneNum = new FocusNode();

  final FocusNode _passwordPin = new FocusNode();

  conductorDetails() async {
    Map _loginBody = {
      "action": "login",
      "username": _phoneNumText.text,
      "password": _securityPin.text
    };
    var _loginHeaders = {
      "Content-Type": "application/json",
      "API-KEY": "525-777-777"
    };
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var response = await http.post(Uri.parse(Constants.appURL),
          body: json.encode(_loginBody), headers: _loginHeaders);
      var conductor = response.body;
      print('-------------------------------${conductor}');
    } else {
      print('------------------------------Connect to internet');
    }
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
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .30,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: AssetImage("assets/tripDetailsHead.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: SvgPicture.asset(
                            "assets/Tab.svg",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * .05,
                            bottom: MediaQuery.of(context).size.width * .05,
                            left: MediaQuery.of(context).size.width * .1,
                            right: MediaQuery.of(context).size.width * .1,
                          ),
                          height: MediaQuery.of(context).size.height * .10,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AutoSizeText(
                                  "Sign In",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-Regular',
                                    color: Color(0xff2acbb9),
                                    // fontSize: 35,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  maxFontSize: 35,
                                  minFontSize: 25,
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  "To Start Working",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-Regular',
                                    color: Color(0xff7f8483),
                                    // fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  maxFontSize: 15,
                                  minFontSize: 10,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .1,
                                      // right:
                                      //     MediaQuery.of(context).size.width * .15,
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height * .3,
                                    // width: MediaQuery.of(context).size.width * .85,
                                    decoration: BoxDecoration(
                                      color: Color(0xffebfaf8)
                                          .withOpacity(0.6100000143051147),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          bottomLeft: Radius.circular(40)),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .1),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              .02),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          TextField(
                                            focusNode: _phoneNum,
                                            autofocus: false,
                                            controller: _phoneNumText,
                                            maxLength: 14,
                                            decoration: InputDecoration(
                                              // icon: Icon(Icons.phone_android),
                                              labelText: 'Mobile Number',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily:
                                                      'Montserrat-Regular',
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.grey),
                                              hintMaxLines: 1,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF2acbb9)),
                                              ),
                                            ),
                                            keyboardType: TextInputType.phone,
                                          ),
                                          TextField(
                                            focusNode: _passwordPin,
                                            controller: _securityPin,
                                            maxLength: 4,
                                            decoration: InputDecoration(
                                              // icon: Icon(Icons.lock),
                                              labelText: '4 Digit PIN',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily:
                                                      'Montserrat-Regular',
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.grey),
                                              hintMaxLines: 1,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF2acbb9)),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.remove_red_eye,
                                                  color: this._showPassword
                                                      ? Colors.grey
                                                      : Colors.blue,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() =>
                                                      this._showPassword =
                                                          !this._showPassword);
                                                },
                                              ),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            obscureText: _showPassword,
                                            onSubmitted: (v) {
                                              // conductorLogin(_phoneNumText.text,
                                              //     _securityPin.text);
                                              conductorDetails();
                                              _phoneNumText.clear();
                                              _securityPin.clear();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .27,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .24),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2acbb9),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Color(0xFF2acbb9),
                                      ),
                                      onPressed: () {
                                        // conductorLogin(_phoneNumText.text,
                                        //     _securityPin.text);
                                        conductorDetails();
                                        _phoneNumText.clear();
                                        _securityPin.clear();
                                      },
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //vk old
                        //  Container(
                        //       height:
                        //           MediaQuery.of(context).size.height * .15,
                        //       width: MediaQuery.of(context).size.width * .75,
                        //       padding: EdgeInsets.all(15.0),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceAround,
                        //         children: <Widget>[
                        //           FlatButton(
                        //             onPressed: () {},
                        //             child: AutoSizeText(
                        //               "Forgot Password",
                        //               style: TextStyle(
                        //                 decoration: TextDecoration.underline,
                        //                 fontFamily: 'Montserrat-Regular',
                        //                 color: Color(0xff7f8483),
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w700,
                        //                 fontStyle: FontStyle.normal,
                        //               ),
                        //                maxLines: 1,
                        //             ),
                        //           ),
                        //           FlatButton(
                        //             onPressed: () {},
                        //             child: AutoSizeText(
                        //               "Contact Manager",
                        //               style: TextStyle(
                        //                 decoration: TextDecoration.underline,
                        //                 fontFamily: 'Montserrat-Regular',
                        //                 color: Color(0xff7f8483),
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w700,
                        //                 fontStyle: FontStyle.normal,
                        //               ),
                        //                maxLines: 1,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //new
                        Container(
                          height: MediaQuery.of(context).size.height * .15,
                          width: MediaQuery.of(context).size.width * .75,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * .05,
                            bottom: MediaQuery.of(context).size.width * .05,
                            left: MediaQuery.of(context).size.width * .1,
                            right: MediaQuery.of(context).size.width * .1,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                TextButton(
                                  // style: ElevatedButton.styleFrom(primary: Colors.white),
                                  onPressed: () {},
                                  child: AutoSizeText(
                                    "Contact Manager",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Montserrat-Regular',
                                      color: Color(0xff7f8483),
                                      // fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    maxFontSize: 12,
                                    minFontSize: 8,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //end
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
    //     } else {
    //       return Scaffold(
    //         body: _loading
    //             ? Center(
    //           child: SpinKitFadingCircle(
    //             color: Color(0xfffed32f),
    //             // color: Colors.blue,
    //           ),
    //         )
    //             : SingleChildScrollView(
    //           child: Container(
    //             height: MediaQuery.of(context).size.height,
    //             width: MediaQuery.of(context).size.width,
    //             child: Stack(
    //               children: <Widget>[
    //                 ListView(
    //                   children: <Widget>[
    //                     Container(
    //                       height:
    //                       MediaQuery.of(context).size.height * .35,
    //                       width: MediaQuery.of(context).size.width,
    //                       // decoration: BoxDecoration(
    //                       //   borderRadius: BorderRadius.circular(30),
    //                       //   // image: DecorationImage(
    //                       //   //   // image: AssetImage(
    //                       //   //   //     "assets/images/tripDetailsHead.png"),
    //                       //   //   fit: BoxFit.fill,
    //                       //   // ),
    //                       // ),
    //                       child: SvgPicture.asset(
    //                         "assets/images/Tab.svg",
    //                         fit: BoxFit.fill,
    //                       ),
    //                     ),
    //                     Row(
    //                       children: <Widget>[
    //                         Container(
    //                           margin: EdgeInsets.only(
    //                             top: MediaQuery.of(context).size.height *
    //                                 .05,
    //                             bottom:
    //                             MediaQuery.of(context).size.height *
    //                                 .4,
    //                             left: MediaQuery.of(context).size.width *
    //                                 .04,
    //                             // right: MediaQuery.of(context).size.width *
    //                             //     .05,
    //                           ),
    //                           height: MediaQuery.of(context).size.height *
    //                               .10,
    //                           width: MediaQuery.of(context).size.width *
    //                               0.30,
    //                           child: Align(
    //                             alignment: Alignment.centerLeft,
    //                             child: Column(
    //                               children: <Widget>[
    //                                 Text(
    //                                   "Sign In",
    //                                   style: TextStyle(
    //                                     fontFamily: 'Montserrat-Regular',
    //                                     color: Color(0xff2acbb9),
    //                                     fontSize: 45,
    //                                     fontWeight: FontWeight.w600,
    //                                     fontStyle: FontStyle.normal,
    //                                   ),
    //                                 ),
    //                                 Text(
    //                                   "To Start Working",
    //                                   style: TextStyle(
    //                                     fontFamily: 'Montserrat-Regular',
    //                                     color: Color(0xff7f8483),
    //                                     fontSize: 18,
    //                                     fontWeight: FontWeight.w500,
    //                                     fontStyle: FontStyle.normal,
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           child: Column(
    //                             children: <Widget>[
    //                               Container(
    //                                 margin: EdgeInsets.only(
    //                                   top: MediaQuery.of(context)
    //                                       .size
    //                                       .height *
    //                                       .05,
    //                                   // bottom: MediaQuery.of(context)
    //                                   //         .size
    //                                   //         .height *
    //                                   //     .02,
    //                                   // left: MediaQuery.of(context).size.width *
    //                                   //     .05,
    //                                   right: MediaQuery.of(context)
    //                                       .size
    //                                       .width *
    //                                       .02,
    //                                 ),
    //                                 height: MediaQuery.of(context)
    //                                     .size
    //                                     .height *
    //                                     .25,
    //                                 width: MediaQuery.of(context)
    //                                     .size
    //                                     .width *
    //                                     .60,
    //                                 decoration: BoxDecoration(
    //                                   color: Color(0xffebfaf8)
    //                                       .withOpacity(
    //                                       0.6100000143051147),
    //                                   borderRadius:
    //                                   BorderRadius.circular(40),
    //                                 ),
    //                                 child: Container(
    //                                   padding: EdgeInsets.all(15.0),
    //                                   child: Column(
    //                                     mainAxisAlignment:
    //                                     MainAxisAlignment.spaceAround,
    //                                     children: <Widget>[
    //                                       TextField(
    //                                         focusNode: _phoneNum,
    //                                         autofocus: false,
    //                                         controller: _phoneNumText,
    //                                         maxLength: 14,
    //                                         decoration: InputDecoration(
    //                                           icon: Icon(
    //                                               Icons.phone_android),
    //                                           labelText: 'Mobile Number',
    //                                         ),
    //                                         keyboardType:
    //                                         TextInputType.phone,
    //                                       ),
    //                                       TextField(
    //                                         focusNode: _passwordPin,
    //                                         controller: _securityPin,
    //                                         maxLength: 4,
    //                                         decoration: InputDecoration(
    //                                           // icon: Icon(Icons.lock),
    //                                           labelText: '4 Digit PIN',
    //                                           enabledBorder:
    //                                           UnderlineInputBorder(
    //                                             borderSide: BorderSide(
    //                                                 color: Color(
    //                                                     0xFF2acbb9)),
    //                                           ),
    //                                           suffixIcon: IconButton(
    //                                             icon: Icon(
    //                                               Icons.remove_red_eye,
    //                                               color:
    //                                               this._showPassword
    //                                                   ? Colors.grey
    //                                                   : Colors.blue,
    //                                               size: 20,
    //                                             ),
    //                                             onPressed: () {
    //                                               setState(() => this
    //                                                   ._showPassword =
    //                                               !this
    //                                                   ._showPassword);
    //                                             },
    //                                           ),
    //                                         ),
    //                                         keyboardType:
    //                                         TextInputType.phone,
    //                                         obscureText: _showPassword,
    //                                         onSubmitted: (v) {
    //                                           _userLogin();
    //                                         },
    //                                       ),
    //                                       Align(
    //                                         alignment: Alignment.topLeft,
    //                                         child: Container(
    //                                           width:
    //                                           MediaQuery.of(context)
    //                                               .size
    //                                               .width *
    //                                               0.25,
    //                                           decoration: BoxDecoration(
    //                                             color: Color(0xff2acbb9),
    //                                             borderRadius:
    //                                             BorderRadius.circular(
    //                                                 13),
    //                                           ),
    //                                           child: FlatButton(
    //                                             onPressed: () {
    //                                               _userLogin();
    //                                               // Navigator.push(
    //                                               //   // Navigator.pushReplacement(
    //                                               //   context,
    //                                               //   MaterialPageRoute(
    //                                               //     // builder: (context) => QrScan(),
    //                                               //     // builder: (context) => NewQrScan(),
    //                                               //     builder: (context) =>
    //                                               //         Notifications(),
    //                                               //   ),
    //                                               // );
    //                                             },
    //                                             child: Icon(
    //                                               Icons.arrow_forward,
    //                                               color: Colors.white,
    //                                               size: 50.0,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                               Container(
    //                                 height: MediaQuery.of(context)
    //                                     .size
    //                                     .height *
    //                                     .25,
    //                                 width: MediaQuery.of(context)
    //                                     .size
    //                                     .width *
    //                                     .60,
    //                                 padding: EdgeInsets.all(10.0),
    //                                 child: Row(
    //                                   mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                                   children: <Widget>[
    //                                     ElevatedButton(
    //                                       onPressed: () {},
    //                                       child: Text(
    //                                         "Forgot Password",
    //                                         style: TextStyle(
    //                                           fontFamily:
    //                                           'Montserrat-Regular',
    //                                           color: Color(0xff7f8483),
    //                                           fontSize: 12,
    //                                           fontWeight: FontWeight.w500,
    //                                           fontStyle: FontStyle.normal,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                     ElevatedButton(
    //                                       onPressed: () =>
    //                                           _contactmanager(),
    //                                       child: Text(
    //                                         "Contact Manager",
    //                                         style: TextStyle(
    //                                           fontFamily:
    //                                           'Montserrat-Regular',
    //                                           color: Color(0xff7f8483),
    //                                           fontSize: 12,
    //                                           fontWeight: FontWeight.w500,
    //                                           fontStyle: FontStyle.normal,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}
