import 'package:flutter/foundation.dart';
import 'lap.dart';

@immutable
class StopwatchState {
  final bool isRunning;
  final Duration elapsed;
  final List<Lap> laps;

  const StopwatchState({
    required this.isRunning,
    required this.elapsed,
    required this.laps,
  });

  const StopwatchState.initial()
    : isRunning = false,
      elapsed = Duration.zero,
      laps = const [];

  StopwatchState copyWith({
    bool? isRunning,
    Duration? elapsed,
    List<Lap>? laps,
  }) {
    return StopwatchState(
      isRunning: isRunning ?? this.isRunning,
      elapsed: elapsed ?? this.elapsed,
      laps: laps ?? this.laps,
    );
  }
}
