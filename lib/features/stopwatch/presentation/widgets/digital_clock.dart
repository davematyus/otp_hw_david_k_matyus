import 'package:flutter/material.dart';
import 'package:otp_hw_david_k_matyus/core/format/duration_format.dart';

class DigitalClock extends StatelessWidget {
  final Duration elapsed;

  const DigitalClock({super.key, required this.elapsed});

  static const textKey = Key('digital_clock_text');

  @override
  Widget build(BuildContext context) {
    return Text(
      DurationFormat.stopwatch(elapsed),
      key: textKey,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        color: const Color(0xFFFFFFFF),
      ),
    );
  }
}
