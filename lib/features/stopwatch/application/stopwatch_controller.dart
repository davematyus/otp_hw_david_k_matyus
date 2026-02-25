import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/lap.dart';
import '../domain/stopwatch_state.dart';

class StopwatchController extends Notifier<StopwatchState> {
  DateTime? _startedAt;
  Duration _accumulated = Duration.zero;
  Duration _lastLapTotal = Duration.zero;

  @override
  StopwatchState build() => const StopwatchState.initial();

  void start(DateTime now) {
    if (state.isRunning) return;
    _startedAt = now;
    state = state.copyWith(isRunning: true);
  }

  void pause(DateTime now) {
    if (!state.isRunning) return;
    _accumulated = _computeElapsed(now);
    _startedAt = null;
    state = state.copyWith(isRunning: false, elapsed: _accumulated);
  }

  void reset() {
    _startedAt = null;
    _accumulated = Duration.zero;
    _lastLapTotal = Duration.zero;
    state = const StopwatchState.initial();
  }

  void clearLaps() {
    _lastLapTotal = Duration.zero;
    state = state.copyWith(laps: const []);
  }

  void lap(DateTime now) {
    if (!state.isRunning) return;

    final total = _computeElapsed(now);
    final lapDur = total - _lastLapTotal;
    _lastLapTotal = total;

    final nextIndex = state.laps.length + 1;
    final newLap = Lap(index: nextIndex, lap: lapDur, total: total);

    state = state.copyWith(elapsed: total, laps: [newLap, ...state.laps]);
  }

  void tick(DateTime now) {
    if (!state.isRunning) return;
    state = state.copyWith(elapsed: _computeElapsed(now));
  }

  Duration _computeElapsed(DateTime now) {
    final startedAt = _startedAt;
    if (startedAt == null) return _accumulated;
    final delta = now.difference(startedAt);
    final total = _accumulated + delta;
    return total.isNegative ? Duration.zero : total;
  }
}
