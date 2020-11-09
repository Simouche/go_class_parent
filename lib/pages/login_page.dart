import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/values/dimensions.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'forgot_password.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = 'login/';

  final usernameInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is Authenticated)
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            else if (state is AuthenticationFailed)
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Connexion echouée")));
          },
          child: CustomPaint(
            painter: AuthPagesTopBG(),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: AUTH_PAGES_BIG_TITLE_MARGIN_TOP,
                      left: AUTH_PAGES_BIG_TITLE_MARGIN_LEFT),
                  child: Text(
                    "Connexion",
                    style: TextStyle(
                        color: WHITE,
                        fontSize: AUTH_PAGES_BIG_TITLE_SIZE,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 150),
                UsernameTextField(controller: usernameInputController),
                PasswordTextField(controller: passwordInputController),
                _RegisterAndLoginButtons(
                    usernameController: usernameInputController,
                    passwordController: passwordInputController),
                SizedBox(height: 50),
                Center(
                    child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, ForgotPassword.routeName),
                        child: Text('Mot de passe oublié ?',
                            style: TextStyle(color: MAIN_COLOR_MEDIUM))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterAndLoginButtons extends StatelessWidget {
  const _RegisterAndLoginButtons(
      {this.usernameController, this.passwordController});

  final usernameController;
  final passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 30, left: 30),
      child: FlatButton(
        color: MAIN_COLOR_MEDIUM,
        child: Text(
          'Se connecter',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(
            LoginSubmitted(usernameController.text, passwordController.text)),
      ),
    );
  }
}
