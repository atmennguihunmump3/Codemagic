import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/models/calendar_event.dart';

class GanttBlock extends StatelessWidget {
  final CalendarEvent event;
  final DateTime baseDate;
  final int daysCount;
  const GanttBlock({super.key, required this.event, required this.baseDate, required this.daysCount});

  Color _color(String line) {
    if (line.contains("1") || line.contains("A")) return AppColors.accentGreen;
    if (line.contains("2") || line.contains("B")) return AppColors.accentOrange;
    return AppColors.accentBlue;
  }

  @override
  Widget build(BuildContext context) {
    final line = event.parsedData?["lineName"] ?? "";
    final startOffset = event.start.difference(DateTime(baseDate.year, baseDate.month, baseDate.day)).inDays;
    final endOffset = event.end.difference(DateTime(baseDate.year, baseDate.month, baseDate.day)).inDays;
    final span = (endOffset - startOffset).clamp(1, daysCount);
    if (startOffset >= daysCount || (startOffset + span) <= 0) return const SizedBox();
    return Positioned(
      left: (startOffset / daysCount) * MediaQuery.of(context).size.width,
      width: (span / daysCount) * MediaQuery.of(context).size.width,
      height: 36,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(color: _color(line), borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
        child: Text(event.parsedData?["taskDetails"] ?? "", style: const TextStyle(color: Colors.white, fontSize: 11), overflow: TextOverflow.ellipsis),
      ),
    );
  }
}