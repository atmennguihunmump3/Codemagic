import 'package:flutter/material.dart';
import '../../core/utils/permission_helper.dart';
import '../../core/utils/syntax_parser.dart';
import '../../core/models/calendar_event.dart';
import '../../core/services/google_calendar_service.dart';

class AttendanceFormScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  final DateTime initialDate;
  const AttendanceFormScreen({
    super.key,
    required this.accessLevel,
    required this.initialDate,
  });

  @override
  State<AttendanceFormScreen> createState() => _AttendanceFormScreenState();
}

class _AttendanceFormScreenState extends State<AttendanceFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _status = "Absent";
  late DateTime _date;
  bool _saving = false;
  final _service = GoogleCalendarService();

  @override
  void initState() {
    super.initState();
    _date = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _saving = true);

    final title = SyntaxParser.buildTitle("attendance", {
      "employeeName": _name.text.trim(),
      "status": _status,
    });

    // 考勤事件：当天 00:00 ~ 23:59
    final start = DateTime(_date.year, _date.month, _date.day);
    final end = DateTime(_date.year, _date.month, _date.day, 23, 59);

    await _service.createEvent(
      CalendarEvent(
        id: "",
        start: start,
        end: end,
        title: title,
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Attendance Record"),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: "Employee Name",
                hintText: "e.g. Wani",
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Please enter employee name";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Status selection
            const Text("Status:", style: TextStyle(fontWeight: FontWeight.w600)),
            RadioListTile<String>(
              title: const Text("Absent"),
              value: "Absent",
              groupValue: _status,
              onChanged: (val) {
                if (val != null) setState(() => _status = val);
              },
            ),
            RadioListTile<String>(
              title: const Text("Leave"),
              value: "Leave",
              groupValue: _status,
              onChanged: (val) {
                if (val != null) setState(() => _status = val);
              },
            ),

            const SizedBox(height: 16),

            // Date picker
            ListTile(
              title: Text("Date: $_date"),
              trailing: const Icon(Icons.edit_calendar),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    _date = DateTime(picked.year, picked.month, picked.day);
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Save Record"),
            ),
          ],
        ),
      ),
    );
  }
}