import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otp_hw_david_k_matyus/core/format/duration_format.dart';
import 'package:otp_hw_david_k_matyus/core/time/now_provider.dart';
import 'package:otp_hw_david_k_matyus/core/time/tick_source.dart';
import 'package:otp_hw_david_k_matyus/core/time/tick_source_provider.dart';
import 'package:otp_hw_david_k_matyus/features/stopwatch/application/stopwatch_providers.dart';
import 'package:otp_hw_david_k_matyus/features/stopwatch/presentation/stopwatch_screen.dart';
import 'package:otp_hw_david_k_matyus/features/stopwatch/presentation/widgets/digital_clock.dart';

void main() {
  group('StopwatchScreen widget tests', () {
    testWidgets(
      'Start -> tick updates UI, Pause freezes, Reset clears, Lap adds row',
      (tester) async {
        final manual = ManualTickSource();
        var now = DateTime(2026, 1, 1, 12, 0, 0, 0);

        final container = ProviderContainer(
          overrides: [
            tickSourceProvider.overrideWithValue(manual),
            nowProvider.overrideWithValue(() => now),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: StopwatchScreen(provideTickSource: false),
            ),
          ),
        );

        await tester.pump();

        expect(find.byKey(DigitalClock.textKey), findsOneWidget);
        expect(_digitalText(tester), DurationFormat.stopwatch(Duration.zero));

        await tester.tap(find.text('Start'));
        await tester.pump();

        now = now.add(const Duration(milliseconds: 1230));
        manual.emit(now);
        await tester.pump();

        expect(
          _digitalText(tester),
          DurationFormat.stopwatch(const Duration(milliseconds: 1230)),
        );

        await tester.tap(find.text('Lap'));
        await tester.pump();
        expect(find.textContaining('#1'), findsOneWidget);

        await tester.tap(find.text('Pause'));
        await tester.pump();

        now = now.add(const Duration(seconds: 10));
        manual.emit(now);
        await tester.pump();

        expect(
          _digitalText(tester),
          DurationFormat.stopwatch(const Duration(milliseconds: 1230)),
        );

        await tester.tap(find.text('Reset'));
        await tester.pump();

        expect(_digitalText(tester), DurationFormat.stopwatch(Duration.zero));
        expect(find.textContaining('#1'), findsNothing);
      },
    );

    testWidgets(
      'Provider state sanity: while paused, ticking does not advance',
      (tester) async {
        final manual = ManualTickSource();
        var now = DateTime(2026, 1, 1, 12, 0, 0, 0);

        final container = ProviderContainer(
          overrides: [
            tickSourceProvider.overrideWithValue(manual),
            nowProvider.overrideWithValue(() => now),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: StopwatchScreen(provideTickSource: false),
            ),
          ),
        );

        await tester.pump();

        await tester.tap(find.text('Start'));
        await tester.pump();

        now = now.add(const Duration(seconds: 2));
        manual.emit(now);
        await tester.pump();

        await tester.tap(find.text('Pause'));
        await tester.pump();

        now = now.add(const Duration(seconds: 20));
        manual.emit(now);
        await tester.pump();

        expect(
          container.read(stopwatchProvider).elapsed,
          const Duration(seconds: 2),
        );
        expect(container.read(stopwatchProvider).isRunning, isFalse);
      },
    );
  });
}

String _digitalText(WidgetTester tester) {
  final textWidget = tester.widget<Text>(find.byKey(DigitalClock.textKey));
  return textWidget.data ?? '';
}
