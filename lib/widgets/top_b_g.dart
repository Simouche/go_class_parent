import 'package:flutter/material.dart';

class TopBackGroundImage extends StatelessWidget {
  const TopBackGroundImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage("assets/back_ground.png"),
      width: MediaQuery.of(context).size.width,
    );
  }
}
