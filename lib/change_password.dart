import 'package:conductor_app_flutter/showDialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:conductor_app_flutter/connection.dart' as Constants;
import 'package:flutter_svg/flutter_svg.dart';
import 'navdrawer.dart';
import 'notifications.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _oldPinText = TextEditingController();
  final _newPinText = TextEditingController();
  final _confirmNewPinText = TextEditingController();
  final FocusNode _oldPin = new FocusNode();
  final FocusNode _newPin = new FocusNode();
  final FocusNode _confirmNewPin = new FocusNode();
  bool _showPassword=true;
  bool _showPassword1=true;
  bool _loading = false;
  String conductorName = "";
  String userApiKeys = "";
  int conductorId = 0;

  _getStoredData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      conductorName = sharedPrefs.getString('conductorName')!;
      userApiKeys = sharedPrefs.getString('userApiKey')!;
      conductorId = sharedPrefs.getInt('conductorId')!;
    });
  }

  _getUserPassword() {
    if (_oldPinText.text.isNotEmpty &&
        _newPinText.text.isNotEmpty &&
        _confirmNewPinText.text.isNotEmpty) {
      if (_newPinText.text == _confirmNewPinText.text) {
        setState(() {
          _loading = true;
        });
        _oldPin.unfocus();
        _newPin.unfocus();
        _confirmNewPin.unfocus();
        _checkConnectivity();
      } else {
        int dataStatus = 3;
        String errorText = "New PINs does not match.!!";
        String titleText = "Information.!!";
        String bottomBtnText = "Close";
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) => ShowCustomDialog(
        //     title: titleText,
        //     description: errorText,
        //     buttonText: bottomBtnText,
        //     dataStatus: dataStatus,
        //   ),
        // );
      }
    } else {
      int dataStatus = 3;
      String errorText = "All fields are required.!!";
      String titleText = "Information.!!";
      String bottomBtnText = "Close";
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => ShowCustomDialog(
      //     title: titleText,
      //     description: errorText,
      //     buttonText: bottomBtnText,
      //     dataStatus: dataStatus,
      //   ),
      // );
    }
  }

  _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      int dataStatus = 2;
      String errorText = "You are not connected to any network.!!";
      String titleText = "No Internet.!!";
      String bottomBtnText = "Close";
      setState(() {
        _loading = false;
      });
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => ShowCustomDialog(
      //     title: titleText,
      //     description: errorText,
      //     buttonText: bottomBtnText,
      //     dataStatus: dataStatus,
      //   ),
      // );
    } else {
      _changePassword();
    }
  }

  Future _changePassword() async {
    setState(() {
      _loading = true;
    });
    var _action = "change_password";
    var _oldPassword = _oldPinText.text;
    var _newPassword = _newPinText.text;

    Map _passData = {
      "action": _action,
      "conductor_id": conductorId,
      "old_password": _oldPassword,
      "new_password": _newPassword,
    };
    // print(json.encode(conn.appURL));
    var response = await http.post(
      Uri.parse(Constants.appURL),
      body: json.encode(_passData),
      headers: {"Content-Type": "application/json", "API-KEY": userApiKeys},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _loading = false;
      });

      if (data['data'] != null) {
        var dataStatus = data['data']['data_status'];
        var usrMsg = data['data']['message'];
        if (dataStatus == 1) {
          // int dataStatus = 101;
          // String errorText = "$usrMsg.!!";
          // String titleText = "Success.!!";
          // String bottomBtnText = "Close";
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) => ShowCustomDialog(
          //     title: titleText,
          //     description: errorText,
          //     buttonText: bottomBtnText,
          //     dataStatus: dataStatus,
          //   ),
          // );
        } else {
          // int dataStatus = 0;
          // String errorText = "$usrMsg.!!";
          // String titleText = "Sorry.!!";
          // String bottomBtnText = "Close";
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) => ShowCustomDialog(
          //     title: titleText,
          //     description: errorText,
          //     buttonText: bottomBtnText,
          //     dataStatus: dataStatus,
          //   ),
          // );
          // _oldPinText.clear();
          // _newPinText.clear();
          // _confirmNewPinText.clear();
        }
      } else {
        // int dataStatus = 2;
        // String errorText = "Sorry..Server Connection Problem.!!";
        // String titleText = "No Response.!!";
        // String bottomBtnText = "Close";
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) => ShowCustomDialog(
        //     title: titleText,
        //     description: errorText,
        //     buttonText: bottomBtnText,
        //     dataStatus: dataStatus,
        //   ),
        // );
      }
    }
  }

  @override
  void initState() {
    _getStoredData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              //vk
              elevation: 0,
              //old
              // title: Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     "Transport+",
              //     style: TextStyle(fontStyle: FontStyle.italic),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              //end
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
            body: _loading
                ? Center(
              child: SpinKitFadingCircle(
                color: Color(0xfffed32f),
                // color: Colors.blue,
              ),
            )
                : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height:
                            MediaQuery.of(context).size.height * .25,
                            width: MediaQuery.of(context).size.width,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(30),
                            //   image: DecorationImage(
                            //     image: AssetImage(
                            //         "assets/images/tripDetailsHead.png"),
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            child: SvgPicture.asset(
                              "assets/images/Tab.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .22,
                          right: MediaQuery.of(context).size.width * .05,
                          left: MediaQuery.of(context).size.width * .05,
                        ),
                        child: Container(
                          // width: 328,
                          // height: 200,
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * .14,
                          decoration: BoxDecoration(
                            color: Color(0xff2acbb9)
                                .withOpacity(0.09000000357627869),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffebfbf9),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Color(0xff2acbb9), width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*.3,
                                    height: MediaQuery.of(context).size.height*.15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/profilepic.jpeg"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //vk
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:180,
                                    child: Text(
                                      'conductorName',

                                      style: TextStyle(
                                        fontFamily: 'Montserrat-Regular',
                                        color: Color(0xff888888),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      // minFontSize: 13,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Conductor",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-Regular',
                                            color: Color(0xff888888),
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700
                                        ),
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        // height:10,
                                        width: 20,
                                      ),
                                      // Container(
                                      //           height: MediaQuery.of(context).size.height*.03,
                                      //           width: MediaQuery.of(context).size.width*.23,
                                      //           decoration: BoxDecoration(
                                      //             //  color: Color(0xff2acbb9),
                                      //             borderRadius: BorderRadius.circular(5),
                                      //             border: Border.all(color: Color(0xff2acbb9))
                                      //           ),
                                      //           child: Center(
                                      //             child: AutoSizeText(
                                      //               'ckpkh',
                                      //               style: TextStyle(
                                      //                 color: Color(0xff888888),
                                      //                  fontFamily: 'Montserrat-Regular',
                                      //                  fontWeight: FontWeight.w700,
                                      //                  fontSize: 15,
                                      //                  fontStyle: FontStyle.normal
                                      //               ),
                                      //               maxLines: 1,
                                      //             ),
                                      //           ),
                                      //         ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .45,
                          right: MediaQuery.of(context).size.width * .1,
                          left: MediaQuery.of(context).size.width * .1,
                        ),
                        child: Text(
                          "Change Your Password",
                          style: TextStyle(
                            fontFamily: 'Montserrat-Regular',
                            color: Color(0xff2acbb9),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      //end
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .49,
                          right: MediaQuery.of(context).size.width * .1,
                          left: MediaQuery.of(context).size.width * .25,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            TextField(
                              focusNode: _oldPin,
                              autofocus: false,
                              controller: _oldPinText,
                              maxLength: 4,
                              decoration: InputDecoration(
                                labelText: 'Old PIN',
                                labelStyle:TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat-Regular',
                                    fontStyle: FontStyle.normal,
                                    color: Colors.grey
                                ),
                                hintMaxLines: 1,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF2acbb9)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: this._showPassword ? Colors.grey : Colors.blue,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => this._showPassword = !this._showPassword);
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              obscureText: _showPassword,
                            ),
                            TextField(
                              focusNode: _newPin,
                              autofocus: false,
                              controller: _newPinText,
                              maxLength: 4,
                              decoration: InputDecoration(
                                labelText: 'New 4-digit PIN',
                                labelStyle:TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat-Regular',
                                    fontStyle: FontStyle.normal,
                                    color: Colors.grey
                                ),
                                hintMaxLines: 1,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF2acbb9)),
                                ),
                              ),

                              keyboardType: TextInputType.phone,
                              obscureText: _showPassword1,
                            ),
                            TextField(
                              focusNode: _confirmNewPin,
                              controller: _confirmNewPinText,
                              maxLength: 4,
                              decoration: InputDecoration(
                                labelText: 'Confirm New 4-digit PIN',
                                labelStyle:TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat-Regular',
                                    fontStyle: FontStyle.normal,
                                    color: Colors.grey
                                ),
                                hintMaxLines: 1,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF2acbb9)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: this._showPassword1 ? Colors.grey : Colors.blue,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => this._showPassword1 = !this._showPassword1);
                                  },
                                ),
                              ),

                              keyboardType: TextInputType.phone,
                              obscureText: _showPassword1,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .02,
                                right: MediaQuery.of(context).size.width * .1,
                                // left: MediaQuery.of(context).size.width * .2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff2acbb9),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _getUserPassword();
                                },
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-Regular',
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
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
            body: _loading
                ? Center(
              child: SpinKitFadingCircle(
                color: Color(0xfffed32f),
                // color: Colors.blue,
              ),
            )
                : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height:
                            MediaQuery.of(context).size.height * .40,
                            width: MediaQuery.of(context).size.width,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(30),
                            //   image: DecorationImage(
                            //     image: AssetImage(
                            //         "assets/images/tripDetailsHead.png"),
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            child: SvgPicture.asset(
                              "assets/images/Tab.svg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .38,
                          right: MediaQuery.of(context).size.width * .15,
                          left: MediaQuery.of(context).size.width * .15,
                        ),
                        child: Container(
                          // width: 328,
                          // height: 200,
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * .14,
                          decoration: BoxDecoration(
                            color: Color(0xff2acbb9)
                                .withOpacity(0.09000000357627869),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffebfbf9),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Color(0xff2acbb9), width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/profilepic.jpeg"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    conductorName,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      color: Color(0xff2acbb9),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  Text(
                                    "Conductor",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      color: Color(0xff2acbb9),
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .55,
                          right: MediaQuery.of(context).size.width * .15,
                          left: MediaQuery.of(context).size.width * .15,
                        ),
                        child: Text(
                          "Change Your Password",
                          style: TextStyle(
                            fontFamily: 'Montserrat-Regular',
                            color: Color(0xff278d81),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .60,
                          right: MediaQuery.of(context).size.width * .25,
                          left: MediaQuery.of(context).size.width * .15,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            TextField(
                              focusNode: _oldPin,
                              autofocus: false,
                              controller: _oldPinText,
                              maxLength: 4,
                              decoration: InputDecoration(
                                labelText: 'Old PIN',
                              ),
                              keyboardType: TextInputType.phone,
                              obscureText: true,
                            ),
                            TextField(
                              focusNode: _newPin,
                              autofocus: false,
                              controller: _newPinText,
                              maxLength: 4,
                              decoration: InputDecoration(
                                labelText: 'New 4-digit PIN',
                              ),
                              keyboardType: TextInputType.phone,
                              obscureText: true,
                            ),
                            TextField(
                              focusNode: _confirmNewPin,
                              controller: _confirmNewPinText,
                              maxLength: 4,
                              decoration: InputDecoration(
                                labelText: 'Confirm New 4-digit PIN',
                              ),
                              keyboardType: TextInputType.phone,
                              obscureText: true,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                // alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Color(0xff2acbb9),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _getUserPassword();
                                  },
                                  child: Text(
                                    "Change Password",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                          height:
                          MediaQuery.of(context).size.height * .15,
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
              ),
            ),
          );
        }
      },
    );
  }
}
