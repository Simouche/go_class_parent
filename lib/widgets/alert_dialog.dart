import 'package:flutter/material.dart';
import 'package:go_class_parent/values/Colors.dart';

class MyAlertDialog extends StatelessWidget {
  MyAlertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Image(
          image: const AssetImage("assets/lock.png"),
          height: 64.0,
          width: 64.0,
        ),
      ),
      content: Container(
//          width: 200.0,
        height: 110.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Code has been sent to reset\ a new password.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "You'll shortly receive an email with a code\n to setup a new password",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  'Done',
                  style: TextStyle(color: WHITE),
                ),
                color: MAIN_COLOR_LIGHT,
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
