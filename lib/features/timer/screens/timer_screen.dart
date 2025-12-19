import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_header.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({Key? key}) : super(key: key);

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final notifier = ref.read(timerProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const CustomAppHeader(title: "Focus.Me"),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Timer", style: AppTextStyles.titleLarge),
                const SizedBox(height: 48),
                // Timer Circle Simulation (Optional, but looks better)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: CircularProgressIndicator(
                        value: timerState.initialDuration > 0 
                            ? timerState.remainingSeconds / timerState.initialDuration
                            : 0,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    Text(
                      _formatTime(timerState.remainingSeconds),
                      style: AppTextStyles.timerDisplay,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (timerState.isFinished)
                  Text("Tempo finalizado!", style: AppTextStyles.titleMedium.copyWith(color: AppColors.success)),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reset Button
                    if (timerState.remainingSeconds != timerState.initialDuration || timerState.isFinished)
                       TextButton(
                         onPressed: notifier.reset,
                         child: Text("Resetar", style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey)),
                       ),
                    const SizedBox(width: 32),
                    // Start/Pause Button
                    ElevatedButton(
                      onPressed: notifier.toggle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: timerState.isRunning ? Colors.orange[300] : AppColors.success, 
                        // Prompt says "Botão: Iniciar". Green is standard for Start. 
                        // AppColors.success defined as Green.
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        timerState.isRunning ? "Pausar" : "Iniciar",
                        style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
