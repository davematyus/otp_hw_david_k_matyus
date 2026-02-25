class DurationFormat {
  const DurationFormat._();

  static String stopwatch(Duration d) {
    final ms = d.inMilliseconds;

    final hundreds = (ms ~/ 10) % 100;
    final seconds = (ms ~/ 1000) % 60;
    final minutes = (ms ~/ 60000) % 60;
    final hours = (ms ~/ 3600000);

    String two(int v) => v.toString().padLeft(2, '0');

    if (hours > 0) {
      return '${two(hours)}:${two(minutes)}:${two(seconds)}.${two(hundreds)}';
    }
    return '${two(minutes)}:${two(seconds)}.${two(hundreds)}';
  }

  static String short(Duration d) {
    final totalSeconds = d.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(minutes)}:${two(seconds)}';
  }
}
