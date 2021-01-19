import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/pages/new_password.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/values/dimensions.dart';
import 'package:go_class_parent/widgets/widgets.dart';

class ForgotPassword extends StatelessWidget {
  static const String routeName = 'forgot_password/';

  ForgotPassword({Key key}) : super(key: key);

  final codeInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, newState) {
          switch (newState.runtimeType) {
            case CheckResetCodeLoadingState:
              Scaffold.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Verification de code... Veuillez Patientez.")));
              break;
            case CheckResetCodeFailedState:
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Code invalide.")));
              break;
            case CheckResetCodeSuccessState:
              CheckResetCodeSuccessState state =
                  newState as CheckResetCodeSuccessState;
              Navigator.of(context)
                  .pushNamed(NewPassword.routeName, arguments: state.user);
              break;
          }
        },
        child: SafeArea(
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
                    "Vérification",
                    style: TextStyle(
                        color: WHITE,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 90),
                _UsernameTextField(controller: codeInputController),
                _RegisterAndLoginButtons(controller: codeInputController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField({this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Padding(
        child: TextFormField(
          cursorColor: colorScheme.onSurface,
          controller: controller,
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
  const _RegisterAndLoginButtons({this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 30, left: 30),
      child: FlatButton(
        color: Color(0xff42b1de),
        child: Text(
          'Vérifier',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
            .add(CheckResetPasswordCodeEvent(code: controller.text)),
      ),
    );
  }
}
