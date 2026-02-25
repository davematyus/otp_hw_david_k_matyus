typedef TickCallback = void Function(DateTime now);

abstract class TickSource {
  void start(TickCallback onTick);
  void stop();
  void dispose();
}

class ManualTickSource implements TickSource {
  TickCallback? _cb;

  @override
  void start(TickCallback onTick) => _cb = onTick;

  @override
  void stop() {}

  @override
  void dispose() {}

  void emit(DateTime now) => _cb?.call(now);
}
