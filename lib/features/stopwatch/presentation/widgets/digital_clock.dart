import 'package:flutter/material.dart';
import 'package:otp_hw_david_k_matyus/core/format/duration_format.dart';
import '../../../../core/theme/theme_own.dart';

class DigitalClock extends StatelessWidget {
  final Duration elapsed;

  const DigitalClock({super.key, required this.elapsed});

  static const textKey = Key('digital_clock_text');

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text(
      DurationFormat.stopwatch(elapsed),
      key: textKey,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        color: colors.text,
      ),
    );
  }
}
