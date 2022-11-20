import 'dart:math' show min;

import 'package:flutter/widgets.dart';

import '../inherited_inertia.dart';

/// Inertia animation widget.
///
/// Adds a padding to given [child] based on readings from [Inertia]
/// inherited widget.
class InertiaSpacing extends StatelessWidget {
  final Widget child;

  /// Duration of the stretching animation.
  ///
  /// When the velocity is not directly controlled by the pointer,
  /// this is the duration in which any changes to stretch values will occur.
  final Duration duration;

  /// Curve of the stretching animation.
  ///
  /// When the velocity is not directly controlled by the pointer,
  /// this is the curve which will be used to animate any stretch changes.
  final Curve curve;

  /// Maximum stretch to be applied.
  ///
  /// This is the value at which the spacing will stop growing.
  final double maxStretch;

  const InertiaSpacing({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.maxStretch = 5,
  });

  @override
  Widget build(BuildContext context) {
    final inertia = Inertia.of(context);
    final stretch = min(inertia.value.value.abs(), maxStretch) / 2;
    final padding = inertia.value.axis == Axis.vertical
        ? EdgeInsets.symmetric(vertical: stretch)
        : EdgeInsets.symmetric(horizontal: stretch);

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: padding,
      child: child,
    );
  }
}
