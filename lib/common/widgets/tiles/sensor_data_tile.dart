import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';

class SensorDataTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const SensorDataTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyText2),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.headline2.copyWith(fontSize: 22)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}