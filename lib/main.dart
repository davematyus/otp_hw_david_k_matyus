import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'features/stopwatch/presentation/stopwatch_screen.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const appColors = AppColors(
      dark: Color(0xFF061226),
      card: Color(0xFF00403D),
      text: Color(0xFFFFFFFF),
      lightText: Color(0x99FFFFFF),
      disabledText: Color(0x66FFFFFF),
      disabled: Color(0x66061226),
    );

    return MaterialApp(
      title: 'Stopwatch',
      theme: ThemeData(useMaterial3: true, extensions: const [appColors]),
      darkTheme: ThemeData(useMaterial3: true, extensions: const [appColors]),
      themeMode: ThemeMode.system,
      home: const StopwatchScreen(),
    );
  }
}
