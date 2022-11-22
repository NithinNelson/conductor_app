import 'package:conductor_app_flutter/tripSelection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ShowCustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final int dataStatus;

  ShowCustomDialog({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.dataStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 5.0,
      backgroundColor: dataStatus == 101 || dataStatus==105 || dataStatus==107 ? Colors.green[300] : Colors.redAccent,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          dataStatus == 101 || dataStatus==105
              ? FaIcon(
            FontAwesomeIcons.check,
            size: 80.0,
            color: Colors.white,
          )
              :
          // FaIcon(
          //         FontAwesomeIcons.exclamationCircle,
          //         size: 60.0,
          //         color: Colors.white,
          //       ),
          Text(
            "Message",
            style: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10,),
          Divider(
            height: 2.0,
            color: Colors.white,
          )
        ],
      ),
      content: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        dataStatus == 101 || dataStatus==105 || dataStatus==107
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green[300],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.white)),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            dataStatus==105?
            Navigator.of(context).pop()
                : dataStatus==107
                ?Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TripSelection(),
              ),
            )
                :Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            );
          },
        )
            : ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: dataStatus == 100 ? Colors.greenAccent : Colors.redAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.white)),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async{
            SharedPreferences sharedPref = await SharedPreferences.getInstance();
            sharedPref.setBool('isLoggedIn', false);
            dataStatus == 108
                ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TripSelection(),
              ),
            )
                :
            dataStatus == 100
                ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            )
                : dataStatus == 106
                ?SystemNavigator.pop()
                :Navigator.of(context).pop();
          },
        ),
        // dataStatus == 100 || dataStatus == 106
        //     ? RaisedButton(
        //   color: Colors.redAccent,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10.0),
        //       side: BorderSide(color: Colors.white)),
        //   child: Text(
        //     "No",
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // )
        //     : null,
      ],
      // child: dialogContent(context),
    );
  }
}
