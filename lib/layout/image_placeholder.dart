import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FadeInImagePlaceholder extends StatelessWidget {
  const FadeInImagePlaceholder(
      {Key key,
      @required this.image,
      @required this.placeholder,
      this.child,
      this.duration = const Duration(milliseconds: 500),
      this.excludeFromSemantics = false,
      this.width,
      this.height,
      this.fit})
      : assert(placeholder != null),
        assert(image != null),
        super(key: key);

  /// The target image that we are loading into memory.
  final ImageProvider image;

  /// Widget displayed while the target [image] is loading.
  final Widget placeholder;

  /// What widget you want to display instead of [placeholder] after [image] is
  /// loaded.
  ///
  /// Defaults to display the [image].
  final Widget child;

  /// The duration for how long the fade out of the placeholder and
  /// fade in of [child] should take.
  final Duration duration;

  /// See [Image.excludeFromSemantics].
  final bool excludeFromSemantics;

  /// See [Image.width].
  final double width;

  /// See [Image.height].
  final double height;

  /// See [Image.fit].
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return this.child ?? child;
      },
    );
  }
}
