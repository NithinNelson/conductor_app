import 'package:flutter/material.dart';
import './navdrawer.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
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
      ),
      // drawer: NavDrawer(),
      body: Container(
        padding: EdgeInsets.all(15.0),
        // child: ListView.builder(
        //   itemCount: 15,
        //   itemBuilder: (context, index) {
        //     // if{}
        //     return Card(
        //       child: ListTile(
        //         leading: CircleAvatar(
        //           child: Icon(
        //             Icons.outlined_flag,
        //             color: Colors.white,
        //           ),
        //           backgroundColor: Colors.red[300],
        //         ),
        //         title: Text(
        //             "Text Text(String data, {Key key, TextStyle style, StrutStyle strutStyle, TextAlign textAlign, TextDirection textDirection, Locale locale, bool softWrap, TextOverflow overflow, double textScaleFactor, int maxLines, String semanticsLabel, TextWidthBasis textWidthBasis})"),
        //         onTap: () {},
        //       ),
        //       color: Colors.red[100],
        //       elevation: 0.0,
        //     );
        //   },
        // ),
        child: Center(
          child: Text("No new notifications."),
        ),
      ),
    );
  }
}
