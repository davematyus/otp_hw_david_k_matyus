import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:otp_hw_david_k_matyus/features/stopwatch/application/stopwatch_providers.dart';

void main() {
  test('start -> tick increases elapsed', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final c = container.read(stopwatchProvider.notifier);

    final t0 = DateTime(2026, 1, 1, 12, 0, 0, 0);
    c.start(t0);

    c.tick(t0.add(const Duration(milliseconds: 1230)));

    expect(
      container.read(stopwatchProvider).elapsed,
      const Duration(milliseconds: 1230),
    );
  });

  test('pause freezes elapsed', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final c = container.read(stopwatchProvider.notifier);

    final t0 = DateTime(2026, 1, 1, 12, 0, 0, 0);
    c.start(t0);
    c.tick(t0.add(const Duration(milliseconds: 1500)));
    c.pause(t0.add(const Duration(milliseconds: 1500)));

    c.tick(t0.add(const Duration(milliseconds: 5000)));

    expect(
      container.read(stopwatchProvider).elapsed,
      const Duration(milliseconds: 1500),
    );
    expect(container.read(stopwatchProvider).isRunning, isFalse);
  });

  test('resume continues from accumulated', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final c = container.read(stopwatchProvider.notifier);

    final t0 = DateTime(2026, 1, 1, 12, 0, 0, 0);
    c.start(t0);
    c.tick(t0.add(const Duration(seconds: 2)));
    c.pause(t0.add(const Duration(seconds: 2)));

    final tResume = t0.add(const Duration(seconds: 5));
    c.start(tResume);
    c.tick(tResume.add(const Duration(seconds: 1)));

    expect(
      container.read(stopwatchProvider).elapsed,
      const Duration(seconds: 3),
    );
  });

  test('reset clears elapsed and laps', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final c = container.read(stopwatchProvider.notifier);

    final t0 = DateTime(2026, 1, 1, 12, 0, 0, 0);
    c.start(t0);
    c.tick(t0.add(const Duration(seconds: 1)));
    c.lap(t0.add(const Duration(seconds: 1)));
    expect(container.read(stopwatchProvider).laps, isNotEmpty);

    c.reset();

    final s = container.read(stopwatchProvider);
    expect(s.elapsed, Duration.zero);
    expect(s.isRunning, isFalse);
    expect(s.laps, isEmpty);
  });

  test('lap creates correct lap and total durations', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final c = container.read(stopwatchProvider.notifier);

    final t0 = DateTime(2026, 1, 1, 12, 0, 0, 0);
    c.start(t0);

    c.tick(t0.add(const Duration(seconds: 2)));
    c.lap(t0.add(const Duration(seconds: 2)));

    c.tick(t0.add(const Duration(seconds: 5)));
    c.lap(t0.add(const Duration(seconds: 5)));

    final s = container.read(stopwatchProvider);
    expect(s.laps.length, 2);

    final lap2 = s.laps[0];
    final lap1 = s.laps[1];

    expect(lap1.total, const Duration(seconds: 2));
    expect(lap1.lap, const Duration(seconds: 2));

    expect(lap2.total, const Duration(seconds: 5));
    expect(lap2.lap, const Duration(seconds: 3));
  });

  test('clearLaps clears list and resets lap baseline', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final c = container.read(stopwatchProvider.notifier);

    final t0 = DateTime(2026, 1, 1, 12, 0, 0, 0);
    c.start(t0);
    c.lap(t0.add(const Duration(seconds: 2)));
    expect(container.read(stopwatchProvider).laps.length, 1);

    c.clearLaps();
    expect(container.read(stopwatchProvider).laps, isEmpty);

    c.lap(t0.add(const Duration(seconds: 5)));
    final s = container.read(stopwatchProvider);
    expect(s.laps.single.lap, const Duration(seconds: 5));
    expect(s.laps.single.total, const Duration(seconds: 5));
  });

  test('idempotency: start called twice does not break', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final c = container.read(stopwatchProvider.notifier);
    final t0 = DateTime(2026, 1, 1, 12, 0, 0, 0);

    c.start(t0);
    c.start(t0.add(const Duration(seconds: 1)));

    c.tick(t0.add(const Duration(seconds: 2)));
    expect(
      container.read(stopwatchProvider).elapsed,
      const Duration(seconds: 2),
    );
  });
}
