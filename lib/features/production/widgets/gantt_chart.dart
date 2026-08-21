import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/models/calendar_event.dart';
import 'gantt_block.dart';

class GanttChart extends StatelessWidget {
  final List<CalendarEvent> events;
  final DateTime baseDate;
  const GanttChart({super.key, required this.events, required this.baseDate});

  @override
  Widget build(BuildContext context) {
    final days = DateHelper.daysInRange(baseDate, AppConstants.productionViewDays);
    final lines = events.map((e) => e.parsedData?["lineName"] as String? ?? "Unnamed").toSet().toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const SizedBox(width: 80),
          ...days.map((d) => Expanded(child: Center(child: Text("${d.month}/${d.day}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))))).toList(),
        ]),
        const SizedBox(height: 8),
        ...lines.map((line) {
          final lineEvents = events.where((e) => (e.parsedData?["lineName"] ?? "") == line).toList();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              SizedBox(width: 80, child: Text(line, style: const TextStyle(fontWeight: FontWeight.w600))),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: Stack(
                    children: lineEvents.map((e) => GanttBlock(event: e, baseDate: baseDate, daysCount: days.length)).toList(),
                  ),
                ),
              ),
            ]),
          );
        }).toList(),
      ],
    );
  }
}