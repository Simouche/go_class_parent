
import 'package:flutter/material.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons(
      {Key key,
        this.buttonColor,
        this.text,
        this.height,
        this.width = 250,
        this.onPressed,
        this.textColor = Colors.white})
      : super(key: key);

  final Color buttonColor, textColor;
  final String text;
  final double height, width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => onPressed(),
      child: Container(
        width: this.width,
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: this.buttonColor != null ? this.buttonColor : null,
    );
  }
}