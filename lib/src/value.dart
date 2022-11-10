import 'package:flutter/rendering.dart';

/// Model for passing velocity information down the widget tree.
class InertiaValue {
  final double value;
  final Axis axis;

  const InertiaValue(this.value, this.axis);
  const InertiaValue.vertical(this.value) : axis = Axis.vertical;
  const InertiaValue.horizontal(this.value) : axis = Axis.horizontal;
  static const InertiaValue zero = InertiaValue.vertical(0);

  @override
  String toString() => 'InertiaValue(value: $value, axis: $axis)';
}
