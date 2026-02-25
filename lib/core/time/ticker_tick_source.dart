import 'package:flutter/scheduler.dart';
import 'tick_source.dart';

class TickerTickSource implements TickSource {
  final TickerProvider vsync;
  final Duration? minInterval;

  Ticker? _ticker;
  TickCallback? _onTick;

  Duration _lastElapsed = Duration.zero;

  TickerTickSource({required this.vsync, this.minInterval});

  @override
  void start(TickCallback onTick) {
    _onTick = onTick;
    _ticker ??= vsync.createTicker((elapsed) {
      if (minInterval != null) {
        if (elapsed - _lastElapsed < minInterval!) return;
        _lastElapsed = elapsed;
      }
      _onTick?.call(DateTime.now());
    });

    if (!_ticker!.isActive) _ticker!.start();
  }

  @override
  void stop() {
    _ticker?.stop();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _ticker = null;
    _onTick = null;
  }
}
