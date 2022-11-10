import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inertia/src/listener.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listener_test.mocks.dart';

@GenerateMocks([
  ScrollNotification,
  ScrollMetrics,
])
void main() {
  group(
    'Delta',
    () {
      test(
        'Delta show the difference between current and previous value',
        () {
          expect(const Delta(1, 1).delta, equals(0));
          expect(const Delta(0, 1).delta, equals(1.0));
          expect(const Delta(1, 0).delta, equals(-1.0));
        },
      );
      test(
        'Delta updates current value and makes current one previous',
        () {
          var delta = const Delta(1, 2);
          delta = delta.update(3);

          expect(delta.previous, equals(2.0));
          expect(delta.current, equals(3.0));
        },
      );
      test(
        'Delta.zero produces 0',
        () {
          expect(Delta.zero.delta, equals(0));
        },
      );
    },
  );

  group(
    'InertiaListenerState',
    () {
      test(
        'Velocity is calculated correctly',
        () {
          final state = InertiaListenerState();
          state.lastReadingTime = DateTime(1999, 10, 10);

          state.delta = const Delta(10, 20);
          expect(
            state.calculateVelocity(state.lastReadingTime
                .subtract(const Duration(milliseconds: 10))),
            equals(1.0),
          );

          state.delta = const Delta(0, 0);
          expect(
            state.calculateVelocity(state.lastReadingTime
                .subtract(const Duration(milliseconds: 10))),
            equals(0.0),
          );

          state.delta = const Delta(20, 10);
          expect(
            state.calculateVelocity(state.lastReadingTime
                .subtract(const Duration(milliseconds: 10))),
            equals(-1.0),
          );
        },
      );
      test(
        'Each handled notification updates the lastReadingTime and delta',
        () {
          final state = InertiaListenerState();
          state.initState();
          final mockScrollMetrics = MockScrollMetrics();
          when(mockScrollMetrics.axis).thenReturn(Axis.vertical);
          when(mockScrollMetrics.pixels).thenReturn(1);
          final mockScrollNotification = MockScrollNotification();
          when(mockScrollNotification.metrics).thenReturn(mockScrollMetrics);

          final prevReadingTime = state.lastReadingTime;
          final prevDelta = state.delta;

          state.handleNotification(mockScrollNotification);

          expect(prevReadingTime == state.lastReadingTime, isFalse);
          expect(prevDelta == state.delta, isFalse);
        },
      );
    },
  );
}
