import 'package:flutter/material.dart';
import 'package:go_class_parent/pages/pages.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'login_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage();

  static const String routeName = '/initial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 150),
              Logo(),
              SizedBox(height: 20),
              SizedBox(height: 50),
              AuthButtons(
                buttonColor: MAIN_COLOR_DARK,
                text: 'Se connecter',
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
              ),
              AuthButtons(
                buttonColor: MAIN_COLOR_LIGHT,
                textColor: WHITE,
                text: 'S\'Inscrire',
                onPressed: () {
                  Navigator.pushNamed(context, OtpPage.routeName);
                },
              ),
              // SizedBox(height: 200),
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text('lakkini.com©2020'))),
            ],
          ),
        ),
      ),
    );
  }
}
