import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/calendar_event.dart';
import '../../../core/utils/date_helper.dart';

class ProductionCard extends StatelessWidget {
  final CalendarEvent event;
  final Map<String, dynamic> data;
  const ProductionCard({super.key, required this.event, required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: Border(left: BorderSide(color: AppColors.accentGreen, width: 4)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("🏭 ${data['lineName']}", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text("Task: ${data['taskDetails']}"),
          Text("${DateHelper.formatDisplay(event.start)} – ${DateHelper.formatDisplay(event.end)}"),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text("Details ▶"))),
        ]),
      ),
    );
  }
}