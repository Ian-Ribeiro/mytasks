import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../timer/providers/timer_provider.dart';

// Note: I will need to fix the import path for theme_provider if I made a mistake in previous steps.
// It was created at c:\Users\Carlinhos Fernandin\.gemini\antigravity\scratch\focus_me\lib\core\theme\theme_provider.dart
// So the import should be '../../../core/theme/theme_provider.dart'

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    // Calculate minutes from initialDuration (which is in seconds)
    double currentMinutes = timerState.initialDuration / 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"), 
        // Theme will handle colors, or we can enforce white if we stuck to AppColors
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Aparência", style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text("Modo Escuro"),
              value: themeMode == ThemeMode.dark,
              onChanged: (val) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
            const Divider(height: 32),
            Text("Timer (Pomodoro)", style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            Text("Duração: ${currentMinutes.toInt()} minutos"),
            Slider(
              value: currentMinutes,
              min: 1,
              max: 60,
              divisions: 59,
              label: "${currentMinutes.toInt()} min",
              onChanged: (val) {
                 timerNotifier.setDuration(val.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }
}
