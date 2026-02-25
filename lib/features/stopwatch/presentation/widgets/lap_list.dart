import 'package:flutter/material.dart';
import 'package:otp_hw_david_k_matyus/core/format/duration_format.dart';
import '../../domain/lap.dart';

class LapList extends StatelessWidget {
  final List<Lap> laps;
  final VoidCallback? onClear;

  const LapList({super.key, required this.laps, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF00403D),
      child: Column(
        children: [
          ListTile(
            textColor: const Color(0xFFFFFFFF),
            title: const Text('Laps'),
            trailing: TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0x66061226),
                foregroundColor: const Color(0xFFFFFFFF),
                disabledForegroundColor: const Color(0x66FFFFFF),
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
                ? const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'No laps yet',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
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
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                        trailing: Text(
                          DurationFormat.stopwatch(lap.total),
                          style: const TextStyle(color: Color(0x99FFFFFF)),
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
