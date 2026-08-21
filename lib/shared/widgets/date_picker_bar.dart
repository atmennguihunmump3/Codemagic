import 'package:flutter/material.dart';
import '../../core/utils/date_helper.dart';
import '../../core/constants/app_colors.dart';

class DatePickerBar extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const DatePickerBar({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateHelper.formatDisplay(selectedDate),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const Icon(Icons.calendar_today, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}