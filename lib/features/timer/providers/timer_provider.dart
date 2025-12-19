import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final int remainingSeconds;
  final bool isRunning;
  final bool isFinished;
  final int initialDuration;

  TimerState({
    required this.remainingSeconds,
    required this.isRunning,
    required this.isFinished,
    this.initialDuration = 25 * 60,
  });

  TimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    bool? isFinished,
    int? initialDuration,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
      initialDuration: initialDuration ?? this.initialDuration,
    );
  }
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier()
      : super(TimerState(
          remainingSeconds: 25 * 60,
          isRunning: false,
          isFinished: false,
          initialDuration: 25 * 60,
        ));

  Timer? _timer;

  void setDuration(int minutes) {
    // Update initial duration and reset the timer to this new duration
    final newDuration = minutes * 60;
    state = state.copyWith(initialDuration: newDuration);
    reset(); 
  }

  void start() {
    if (state.isRunning) return;
    
    if (state.isFinished) {
      reset();
    }

    state = state.copyWith(isRunning: true, isFinished: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _timer?.cancel();
        state = state.copyWith(isRunning: false, isFinished: true);
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void toggle() {
    if (state.isRunning) {
      pause();
    } else {
      start();
    }
  }

  void reset() {
    _timer?.cancel();
    state = TimerState(
      remainingSeconds: state.initialDuration, // Use the current updated initialDuration
      isRunning: false,
      isFinished: false,
      initialDuration: state.initialDuration,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
