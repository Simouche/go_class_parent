import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('message received');
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

BuildContext context;

Future displayNotification(Map<String, dynamic> message) async {
  print("notidication received $message");
}

Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: ' + payload);
  }
  print("notification clicked");
  // await Fluttertoast.showToast(
  //     msg: "Notification Clicked",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.black54,
  //     textColor: Colors.white,
  //     fontSize: 16.0);
  /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
}

Future onDidRecieveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: context,
    builder: (BuildContext context) => new CupertinoAlertDialog(
      title: new Text(title),
      content: new Text(body),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: new Text('Ok'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            print("notification clicked");
          },
        ),
      ],
    ),
  );
}
