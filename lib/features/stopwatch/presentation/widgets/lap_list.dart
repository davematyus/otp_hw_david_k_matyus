import 'package:flutter/material.dart';
import 'package:otp_hw_david_k_matyus/core/format/duration_format.dart';
import '../../../../core/theme/theme_own.dart';
import '../../domain/lap.dart';

class LapList extends StatelessWidget {
  final List<Lap> laps;
  final VoidCallback? onClear;

  const LapList({super.key, required this.laps, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Card(
      color: colors.card,
      child: Column(
        children: [
          ListTile(
            textColor: colors.text,
            title: const Text('Laps'),
            trailing: TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                backgroundColor: colors.disabled,
                foregroundColor: colors.text,
                disabledForegroundColor: colors.disabledText,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Clear'),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: laps.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'No laps yet',
                        style: TextStyle(color: colors.text),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: laps.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final lap = laps[i];
                      return ListTile(
                        dense: true,
                        title: Text(
                          '#${lap.index}   +${DurationFormat.stopwatch(lap.lap)}',
                          style: TextStyle(color: colors.text),
                        ),
                        trailing: Text(
                          DurationFormat.stopwatch(lap.total),
                          style: TextStyle(color: colors.lightText),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
