import 'package:flutter/material.dart';
import '../../core/utils/permission_helper.dart';
import '../../core/utils/syntax_parser.dart';
import '../../core/models/calendar_event.dart';
import '../../core/services/google_calendar_service.dart';

class ProductionFormScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  final DateTime initialDate;
  const ProductionFormScreen({super.key, required this.accessLevel, required this.initialDate});
  @override
  State<ProductionFormScreen> createState() => _ProductionFormScreenState();
}

class _ProductionFormScreenState extends State<ProductionFormScreen> {
  final _form = GlobalKey<FormState>();
  final _line = TextEditingController();
  final _task = TextEditingController();
  late DateTime _start;
  late DateTime _end;
  bool _saving = false;
  final _service = GoogleCalendarService();

  @override
  void initState() {
    super.initState();
    _start = DateTime(widget.initialDate.year, widget.initialDate.month, widget.initialDate.day);
    _end = _start.add(const Duration(days: 1));
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final title = SyntaxParser.buildTitle("production", {"lineName": _line.text, "taskDetails": _task.text});
    await _service.createEvent(CalendarEvent(id: "", start: _start, end: _end, title: title));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Production Schedule")),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _line, decoration: const InputDecoration(labelText: "Line Name"), validator: (v) => v?.isEmpty ?? true ? "Required" : null),
            TextFormField(controller: _task, decoration: const InputDecoration(labelText: "Task / Target Details"), validator: (v) => v?.isEmpty ?? true ? "Required" : null),
            const SizedBox(height: 16),
            ListTile(title: Text("Start Date: $_start"), trailing: const Icon(Icons.edit), onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _start, firstDate: DateTime(2025), lastDate: DateTime(2030));
              if (d != null) setState(() => _start = DateTime(d.year, d.month, d.day));
            }),
            ListTile(title: Text("End Date: $_end"), trailing: const Icon(Icons.edit), onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _end, firstDate: DateTime(2025), lastDate: DateTime(2030));
              if (d != null) setState(() => _end = DateTime(d.year, d.month, d.day));
            }),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _saving ? null : _submit, child: _saving ? const CircularProgressIndicator() : const Text("Save Schedule")),
          ],
        ),
      ),
    );
  }
}