import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AttendanceBadge extends StatelessWidget {
  final Map<String, dynamic> data;
  const AttendanceBadge({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final isAbsent = data["status"] == "Absent";
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isAbsent ? AppColors.absentRed.withOpacity(0.08) : AppColors.accentPurple.withOpacity(0.08),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAbsent ? AppColors.absentRed : AppColors.accentPurple,
          child: Text(data["employeeName"][0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text("👷 ${data["employeeName"]}"),
        subtitle: Text(data["status"]),
      ),
    );
  }
}