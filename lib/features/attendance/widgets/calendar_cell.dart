import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/models/calendar_event.dart';

class CalendarCell extends StatelessWidget {
  final DateTime day;
  final DateTime currentMonth;
  final List<CalendarEvent> events;
  const CalendarCell({super.key, required this.day, required this.currentMonth, required this.events});

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = day.month == currentMonth.month;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Text("${day.day}", style: TextStyle(fontSize: 11, color: isCurrentMonth ? AppColors.textMain : AppColors.textMuted)),
          ...events.take(2).map((e) {
            final data = e.parsedData;
            final isAbs = data?["status"] == "Absent";
            return Container(
              width: double.infinity,
              color: isAbs ? AppColors.absentRed.withOpacity(0.15) : AppColors.accentPurple.withOpacity(0.15),
              child: Text("${data?["employeeName"][0]}", textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: isAbs ? AppColors.absentRed : AppColors.accentPurple)),
            );
          }).toList(),
        ],
      ),
    );
  }
}