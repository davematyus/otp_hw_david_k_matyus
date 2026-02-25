import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/now_provider.dart';
import '../../../core/time/tick_source.dart';
import '../../../core/time/tick_source_provider.dart';
import '../../../core/time/ticker_tick_source.dart';
import '../application/stopwatch_providers.dart';
import 'widgets/analog_clock.dart';
import 'widgets/digital_clock.dart';
import 'widgets/lap_list.dart';

class StopwatchScreen extends ConsumerStatefulWidget {
  final bool provideTickSource;

  const StopwatchScreen({super.key, this.provideTickSource = true});

  @override
  ConsumerState<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends ConsumerState<StopwatchScreen>
    with SingleTickerProviderStateMixin {
  late final TickSource _tickSource;

  @override
  void initState() {
    super.initState();

    _tickSource = widget.provideTickSource
        ? TickerTickSource(
            vsync: this,
            minInterval: const Duration(milliseconds: 16),
          )
        : ref.read(tickSourceProvider);

    _tickSource.start((now) {
      if (!mounted) return;
      ref.read(stopwatchProvider.notifier).tick(now);
    });
  }

  @override
  void dispose() {
    _tickSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.provideTickSource) {
      return _StopwatchScreenBody();
    }

    return ProviderScope(
      overrides: [tickSourceProvider.overrideWithValue(_tickSource)],
      child: _StopwatchScreenBody(),
    );
  }
}

class _StopwatchScreenBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stopwatchProvider);
    final c = ref.read(stopwatchProvider.notifier);
    final now = ref.read(nowProvider);

    final mainCard = Card(
      color: const Color(0xFF00403D),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DigitalClock(elapsed: s.elapsed),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.width >= 800 ? 320 : 220,
              child: AnalogClock(elapsed: s.elapsed),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FilledButton(
                  onPressed: s.isRunning
                      ? () => c.pause(now())
                      : () => c.start(now()),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF061226),
                  ),
                  child: Text(s.isRunning ? 'Pause' : 'Start'),
                ),
                OutlinedButton(
                  onPressed: (s.elapsed == Duration.zero && s.laps.isEmpty)
                      ? null
                      : () => c.reset(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF061226), width: 2),
                    foregroundColor: const Color(0xFFFFFFFF),
                    disabledForegroundColor: const Color(0x66FFFFFF),
                  ),
                  child: const Text('Reset'),
                ),
                OutlinedButton(
                  onPressed: s.isRunning ? () => c.lap(now()) : null,
                  style: ButtonStyle(
                    side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                      const enabled = BorderSide(
                        color: Color(0xFF061226),
                        width: 2,
                      );
                      const disabled = BorderSide(
                        color: Color(0x66061226),
                        width: 2,
                      );
                      return states.contains(WidgetState.disabled)
                          ? disabled
                          : enabled;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      const enabled = Color(0xFFFFFFFF);
                      const disabled = Color(0x66FFFFFF);
                      return states.contains(WidgetState.disabled)
                          ? disabled
                          : enabled;
                    }),
                  ),
                  child: const Text('Lap'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final lapCard = LapList(
      laps: s.laps,
      onClear: s.laps.isEmpty ? null : () => c.clearLaps(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF061226),
      appBar: AppBar(
        backgroundColor: const Color(0xFF061226),
        title: const Text(
          'Stopwatch',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;

            if (!isWide) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    mainCard,
                    const SizedBox(height: 12),
                    Expanded(child: lapCard),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: mainCard,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: lapCard),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
