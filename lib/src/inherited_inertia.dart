import 'package:flutter/widgets.dart';

import 'value.dart';

/// Inherited widget passing the velocity and animation behavior
/// information down the widget tree.
class Inertia extends InheritedWidget {
  /// Calculated velocity information.
  final InertiaValue value;

  const Inertia({
    super.key,
    required super.child,
    this.value = InertiaValue.zero,
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
      oldWidget.value.axis != value.axis;
}
