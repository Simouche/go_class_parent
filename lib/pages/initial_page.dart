import 'package:flutter/material.dart';
import 'package:go_class_parent/pages/pages.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';

import 'login_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage();

  static const String routeName = '/initial';
  static var mcontext;

  @override
  Widget build(BuildContext context) {
    mcontext = context;
    // todo add multi bloc consumer or listener to check notification token and send it
    NewVersion(context: context, dialogText: "Nouvelle Version Disponible!")
        .showAlertIfNecessary();

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

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      InAppUpdate.performImmediateUpdate()
          .then((value) => Navigator.pushNamed(mcontext, LoginPage.routeName));
    }).catchError((e) => print("error from updater $e"));
  }
}
