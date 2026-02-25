import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stopwatch_controller.dart';
import '../domain/stopwatch_state.dart';

final stopwatchProvider = NotifierProvider<StopwatchController, StopwatchState>(
  StopwatchController.new,
);
