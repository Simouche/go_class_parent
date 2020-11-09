import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_class_parent/values/dimensions.dart';

class UsernameTextField extends StatelessWidget {
  UsernameTextField({this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Padding(
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-z]"))
          ],
          cursorColor: colorScheme.onSurface,
          controller: controller,
          decoration: InputDecoration(
            hintText: "Nom d'utilisateur",
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

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({this.controller});

  final controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Padding(
        child: TextFormField(
          cursorColor: colorScheme.onSurface,
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Mot de passe",
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

class ConfirmPasswordTextField extends StatelessWidget {
  const ConfirmPasswordTextField({this.controller});

  final controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Padding(
        child: TextFormField(
          cursorColor: colorScheme.onSurface,
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Confirmez le mot de passe",
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

class EmailTextField extends StatelessWidget {
  const EmailTextField({this.controller});

  final controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Padding(
        child: TextFormField(
          cursorColor: colorScheme.onSurface,
          controller: controller,
          decoration: InputDecoration(
            hintText: "E-mail",
            labelStyle: TextStyle(letterSpacing: mediumLetterSpacing),
          ),
          keyboardType: TextInputType.emailAddress,
          autovalidate: true,
          autocorrect: false,
          validator: (_) {
            //return !state.isEmailValid ? 'Email invalide' : null;
          },
          style: TextStyle(),
          /*onChanged: (value) {
                    email = value;
                  },*/
        ),
        padding: EdgeInsets.only(top: 10, right: 30, left: 30),
      ),
    );
  }
}
