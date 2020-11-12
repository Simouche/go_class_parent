import 'package:flutter/material.dart';
import 'package:go_class_parent/pages/pages.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/values/dimensions.dart';
import 'package:go_class_parent/widgets/widgets.dart';

class ForgotPassword extends StatelessWidget {
  static const String routeName = 'forgot_password/';

  ForgotPassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomPaint(
          painter: AuthPagesTopBG(),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: AUTH_PAGES_BIG_TITLE_MARGIN_TOP,
                    left: AUTH_PAGES_BIG_TITLE_MARGIN_LEFT),
                child: Text(
                  "Mot de passe Oublié",
                  style: TextStyle(
                      color: WHITE,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 90),
              _UsernameTextField(),
              _RegisterAndLoginButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _usernameController = TextEditingController();

    return Container(
      child: Padding(
        child: TextFormField(
          cursorColor: colorScheme.onSurface,
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Code Personnel",
            labelStyle: TextStyle(letterSpacing: mediumLetterSpacing),
          ),
          style: TextStyle(),
          /* onChanged: (value) {
                    nom = value;
                  },*/
        ),
        padding: EdgeInsets.only(top: 10, right: 30, left: 30),
      ),
    );
  }
}

class _RegisterAndLoginButtons extends StatelessWidget {
  const _RegisterAndLoginButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 30, left: 30),
      child: FlatButton(
        color: Color(0xff42b1de),
        child: Text(
          'Réinitialiser le Mot de Passe',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        onPressed: () => Navigator.of(context).pushNamed(NewPassword
            .routeName) /*showDialog(
          context: context,
          builder: (_) => MyAlertDialog(),
          barrierDismissible: true,
        )*/
        ,
      ),
    );
  }
}
