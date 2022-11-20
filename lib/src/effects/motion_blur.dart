import 'dart:math' show min, max;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../inherited_inertia.dart';

/// Motion blur animation widget.
///
/// Blurs given [child] based on readings from [Inertia] inherited widget.
class MotionBlur extends StatelessWidget {
  final Widget child;

  /// Maximum blur to be applied.
  ///
  /// Caps the blur sigma to given value, avoiding nauseating effect.
  final double maxBlur;

  /// Blur lower cut off.
  ///
  /// Prevents the effect to be applied to [Scrollable]s with low velocity.
  /// When the velocity is low, users are still able to see children's content
  /// clearly. Applying blur at those speeds causes unwanted visibility issues.
  final double deadZone;

  const MotionBlur({
    super.key,
    required this.child,
    this.maxBlur = 5,
    this.deadZone = 5,
  });

  @override
  Widget build(BuildContext context) {
    final inertia = Inertia.of(context);
    final velocity = max<double>(
      0,
      min(inertia.value.value.abs(), maxBlur + deadZone) - deadZone,
    );
    final filter = inertia.value.axis == Axis.vertical
        ? ImageFilter.blur(sigmaY: velocity)
        : ImageFilter.blur(sigmaX: velocity);

    return BackdropFilter(
      filter: filter,
      child: child,
    );
  }
}
