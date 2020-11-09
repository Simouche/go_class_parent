import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/values/dimensions.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'home_page.dart';

class SignUpPage extends StatelessWidget {
  static const String routeName = 'register/';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess)
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (Route<dynamic> route) => false);
          else if (state is RegistrationFail)
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Inscription echouée")));
        },
        child: SafeArea(
          child: CustomPaint(
            painter: AuthPagesTopBG(),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: AUTH_PAGES_BIG_TITLE_MARGIN_TOP,
                      left: AUTH_PAGES_BIG_TITLE_MARGIN_LEFT),
                  child: Text(
                    "Commencez",
                    style: TextStyle(
                        color: WHITE,
                        fontSize: AUTH_PAGES_BIG_TITLE_SIZE,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 100),
                UsernameTextField(controller: usernameController),
                // EmailTextField(),
                PasswordTextField(controller: passwordController),
                ConfirmPasswordTextField(),
                SizedBox(height: 50),
                // _CheckBox(),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                  return state is Authenticating
                      ? Center(child: CircularProgressIndicator())
                      : _RegisterAndLoginButtons(
                          usernameController: usernameController,
                          passwordController: passwordController);
                }),
                SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _AlreadyUser(),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckBoxState();
  }
}

class _CheckBoxState extends State<_CheckBox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Accept '),
          Text(
            'Terms of Services ',
            style: textStyle,
          ),
          Text('& '),
          Text(
            'Privacy Policy',
            style: textStyle,
          )
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: _isChecked,
      onChanged: (val) {
        setState(
          () {
            _isChecked = val;
            if (val == true) {
              // _currText = t;
            }
          },
        );
      },
    );
  }

  get textStyle => TextStyle(
        color: MAIN_COLOR_LIGHT,
      );
}

class _AlreadyUser extends StatelessWidget {
  const _AlreadyUser();

  @override
  Widget build(BuildContext context) {
    return //Align(

        Container(
            //Padding(
            //  padding: EdgeInsets.only(top: , left: 50, right: 50),
            //  alignment: Alignment.bottomCenter,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 70.0),
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Text(
                  'Vous avez déja un compte ?',
                  style: TextStyle(color: BLACK),
                ),
                SizedBox(
                  width: 2,
                ),
                FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Login ->',
                      style: TextStyle(color: MAIN_COLOR_MEDIUM),
                    ))
              ],
            ));
  }
}

class _RegisterAndLoginButtons extends StatelessWidget {
  const _RegisterAndLoginButtons(
      {this.usernameController, this.passwordController});

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final AuthenticationBloc bloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return Padding(
      padding: EdgeInsets.only(top: 10, right: 30, left: 30),
      child: FlatButton(
        color: MAIN_COLOR_LIGHT,
        child: Text(
          'Créez le compte',
          style: TextStyle(
              color: WHITE, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        onPressed: () {
          bloc.add(RegistrationSubmitted(usernameController.text,
              passwordController.text, bloc.registrationCode));
        },
      ),
    );
  }
}
