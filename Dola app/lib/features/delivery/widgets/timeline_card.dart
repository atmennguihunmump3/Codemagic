import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/calendar_event.dart';
import '../../../core/utils/date_helper.dart';

class TimelineCard extends StatelessWidget {
  final CalendarEvent event;
  final Map<String, dynamic> data;
  const TimelineCard({super.key, required this.event, required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: Border(left: BorderSide(color: AppColors.accentBlue, width: 4)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("🚚 Delivery - ${data['route']}", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text("Driver: ${data['driver']}"),
          Text("Destination: ${data['destination']}"),
          Text("${DateHelper.formatDisplay(event.start)}  ${TimeOfDay.fromDateTime(event.start).format(context)} – ${TimeOfDay.fromDateTime(event.end).format(context)}"),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text("Details ▶"))),
        ]),
      ),
    );
  }
}