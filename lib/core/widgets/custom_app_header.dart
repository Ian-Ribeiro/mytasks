import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/settings/screens/settings_screen.dart';

class CustomAppHeader extends StatelessWidget {
  final String title;
  final bool showSettings;
  final bool showBack;

  const CustomAppHeader({
    Key? key,
    required this.title,
    this.showSettings = false,
    this.showBack = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? AppColors.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Status Bar Simulation (User Requested "9:41")
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("9:41", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Row(
                    children: [
                      Icon(Icons.signal_cellular_alt, size: 16),
                      SizedBox(width: 4),
                      Icon(Icons.wifi, size: 16),
                      SizedBox(width: 4),
                      Icon(CupertinoIcons.battery_25_percent, size: 16), // Example
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                   if (showBack) 
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0), // IconButton has internal padding
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero, // Align closely if needed, or default
                          constraints: const BoxConstraints(), // To remove extra constraints
                        ),
                      ),
                    Text(
                      title,
                      style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                if (showSettings)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                    child: const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
