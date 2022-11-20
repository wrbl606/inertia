import 'dart:async';

import 'package:flutter/widgets.dart';

import 'inherited_inertia.dart';
import 'value.dart';

/// Parent for Inertia children (like [InertiaSpacing]).
///
/// It will listen to [Scrollable]s put in the [child] and provide the
/// velocity information to [Inertia] inherited widget which will be then
/// used by Inertia children widgets (like [InertiaSpacing]).
///
/// Configure the behavior via [duration], [curve] and [maxBlur] attributes.
class InertiaListener extends StatefulWidget {
  /// Child to be listened to.
  ///
  /// The [Scrollable] widget doesn't have to be put directly here,
  /// [ScrollNotification] events will bubble up to here (unless other handler
  /// consumed those).
  final Widget child;

  const InertiaListener({
    super.key,
    required this.child,
  });

  @override
  State<InertiaListener> createState() => InertiaListenerState();
}

@visibleForTesting
class InertiaListenerState extends State<InertiaListener> {
  late final StreamController<InertiaValue> _velocity;

  /// Velocity stream updated with each scroll notification handled in [handleNotification].
  Stream<InertiaValue> get velocity$ => _velocity.stream;

  /// Last obtained scroll pixel positions for velocity calculation.
  @visibleForTesting
  Delta delta = Delta.zero;

  /// Last reading time for velocity calculation.
  @visibleForTesting
  DateTime lastReadingTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _velocity = StreamController.broadcast();
  }

  @override
  void dispose() {
    _velocity.close();
    super.dispose();
  }

  static const _inertiaConstructors = {
    Axis.vertical: InertiaValue.vertical,
    Axis.horizontal: InertiaValue.horizontal,
  };

  /// Obtains and interprets scroll notifications from the [Scrollable]
  /// children.
  @visibleForTesting
  bool handleNotification(ScrollNotification notification) {
    delta = delta.update(notification.metrics.pixels);
    final currentTime = DateTime.now();
    _velocity.add(_inertiaConstructors[notification.metrics.axis]!(
        calculateVelocity(currentTime)));

    lastReadingTime = currentTime;
    return false;
  }

  /// Calculates [Scrollable]'s current velocity.
  ///
  /// Uses [lastReadingTime] and [delta] fields to obtain a change that
  /// happened since the last scroll notification.
  ///
  /// Note: Time delta is calculated at milliseconds level so it may happen
  /// that the delta will be 0. To avoid division by zero, a value of 1 will be
  /// substituted.
  @visibleForTesting
  double calculateVelocity(DateTime currentTime) {
    final timePassed = lastReadingTime.millisecondsSinceEpoch -
        currentTime.millisecondsSinceEpoch;
    return (delta.current - delta.previous) / (timePassed > 0 ? timePassed : 1);
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: handleNotification,
        child: StreamBuilder<InertiaValue>(
          stream: velocity$,
          initialData: InertiaValue.zero,
          builder: (context, snapshot) => Inertia(
            value: snapshot.data!,
            child: widget.child,
          ),
        ),
      );
}

/// Delta calculation container.
///
/// Holds [current] and [previous] values which are considered subsequent
/// and calculates the [delta] (or change) between the two.
@visibleForTesting
class Delta {
  /// Previously obtained reading.
  final double previous;

  /// Currently obtained reading.
  final double current;

  const Delta(this.previous, this.current);

  /// Zeroed delta.
  static const zero = Delta(0, 0);

  /// Change detected between the [current] and [previous] reading.
  double get delta => current - previous;

  /// Pushes [current] value to [previous] field, and puts [value] as [current].
  Delta update(double value) => Delta(current, value);

  @override
  String toString() => 'Delta(prev: $previous, current: $current)';
}
