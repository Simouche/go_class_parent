import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/values/dimensions.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'pages.dart';

class OtpPage extends StatelessWidget {
  static const String routeName = 'otp/';

  final registrationCodeInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listenWhen: (oldState, newState) {
          return oldState != newState;
        },
        listener: (context, state) {
          if (state is RegistrationCodeValid) {
            Navigator.of(context).popAndPushNamed(SignUpPage.routeName);
          } else if (state is RegistrationCodeInvalid) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Code invalide ou expiré.")));
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
                    "Verification",
                    style: TextStyle(
                        color: WHITE,
                        fontSize: AUTH_PAGES_BIG_TITLE_SIZE,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 90),
                _UsernameTextField(
                  registrationCodeInputController:
                      registrationCodeInputController,
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                  return state is Authenticating
                      ? Center(child: CircularProgressIndicator())
                      : _RegisterAndLoginButtons(
                          registrationCodeInputController:
                              registrationCodeInputController);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField({this.registrationCodeInputController});

  final registrationCodeInputController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Padding(
        child: TextFormField(
          cursorColor: colorScheme.onSurface,
          controller: registrationCodeInputController,
          decoration: InputDecoration(
            hintText: "Code personnel",
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
  const _RegisterAndLoginButtons({this.registrationCodeInputController});

  final registrationCodeInputController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 30, left: 30),
      child: FlatButton(
        color: Color(0xff42b1de),
        child: Text(
          'Verifier',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(
            CodeConfirmationSubmitted(registrationCodeInputController.text)),
      ),
    );
  }
}
