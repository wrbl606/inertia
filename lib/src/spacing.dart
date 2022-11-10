import 'dart:math' show min;

import 'package:flutter/widgets.dart';

import 'inherited_inertia.dart';

/// Inertia animation widget.
///
/// Adds a padding to given [child] based on readings from [Inertia]
/// inherited widget.
class InertiaSpacing extends StatelessWidget {
  final Widget child;

  const InertiaSpacing({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final inertia = Inertia.of(context);
    final stretch = min(inertia.value.value.abs(), inertia.maxStretch) / 2;
    final padding = inertia.value.axis == Axis.vertical
        ? EdgeInsets.symmetric(vertical: stretch)
        : EdgeInsets.symmetric(horizontal: stretch);

    return AnimatedContainer(
      duration: inertia.duration,
      curve: inertia.curve,
      padding: padding,
      child: child,
    );
  }
}
