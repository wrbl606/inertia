import 'package:flutter/widgets.dart';

import 'value.dart';

/// Inherited widget passing the velocity and animation behavior
/// information down the widget tree.
class Inertia extends InheritedWidget {
  /// Calculated velocity information.
  final InertiaValue value;

  /// Duration of the stretching animation.
  ///
  /// When the velocity is not directly controlled by the pointer,
  /// this is the duration in which any changes to Inertia children
  /// (like [InertiaSpacing]) stretch values will occur.
  final Duration duration;

  /// Curve of the stretching animation.
  ///
  /// When the velocity is not directly controlled by the pointer,
  /// this is the curve which will be used to animate any changes to
  /// Inertia children (like [InertiaSpacing]).
  final Curve curve;

  /// Maximum stretch to be applied to Inertia children (like [InertiaSpacing]).
  final double maxStretch;

  const Inertia({
    super.key,
    required super.child,
    this.value = InertiaValue.zero,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.maxStretch = 5,
  });

  static Inertia of(BuildContext context) {
    final Inertia? result =
        context.dependOnInheritedWidgetOfExactType<Inertia>();
    assert(
      result != null,
      'No Inertia widget found in given context.'
      'Make sure an InertiaListener widget is put somewhere higher in the widget'
      'tree.',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(Inertia oldWidget) =>
      oldWidget.value.value != value.value ||
      oldWidget.value.axis != value.axis ||
      oldWidget.duration != duration ||
      oldWidget.curve != curve ||
      oldWidget.maxStretch != maxStretch;
}
