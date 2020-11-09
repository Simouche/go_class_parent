import 'package:flutter/material.dart';
import 'package:go_class_parent/layout/image_placeholder.dart';

class Logo extends StatelessWidget {
  const Logo();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        children: [
          Container(
            child: FadeInImagePlaceholder(
              image: const AssetImage('assets/logo.png'),
              placeholder: Container(
                width: 10,
                height: 10,
              ),
            ),
            width: 150,
            height: 100,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
