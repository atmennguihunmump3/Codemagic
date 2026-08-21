import 'package:flutter/material.dart';
import '../../core/utils/permission_helper.dart';
import '../../core/utils/syntax_parser.dart';
import '../../core/models/calendar_event.dart';
import '../../core/services/google_calendar_service.dart';

class DeliveryFormScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  final DateTime initialDate;
  const DeliveryFormScreen({super.key, required this.accessLevel, required this.initialDate});
  @override
  State<DeliveryFormScreen> createState() => _DeliveryFormScreenState();
}

class _DeliveryFormScreenState extends State<DeliveryFormScreen> {
  final _form = GlobalKey<FormState>();
  final _route = TextEditingController();
  final _driver = TextEditingController();
  final _dest = TextEditingController();
  late DateTime _start;
  late DateTime _end;
  bool _saving = false;
  final _service = GoogleCalendarService();

  @override
  void initState() {
    super.initState();
    _start = DateTime(widget.initialDate.year, widget.initialDate.month, widget.initialDate.day, 9);
    _end = DateTime(widget.initialDate.year, widget.initialDate.month, widget.initialDate.day, 18);
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final title = SyntaxParser.buildTitle("delivery", {
      "route": _route.text,
      "driver": _driver.text,
      "destination": _dest.text,
    });
    await _service.createEvent(CalendarEvent(id: "", start: _start, end: _end, title: title));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Delivery Schedule")),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _route, decoration: const InputDecoration(labelText: "Route / Line"), validator: (v) => v?.isEmpty ?? true ? "Required" : null),
            TextFormField(controller: _driver, decoration: const InputDecoration(labelText: "Driver Name"), validator: (v) => v?.isEmpty ?? true ? "Required" : null),
            TextFormField(controller: _dest, decoration: const InputDecoration(labelText: "Destination Details"), validator: (v) => v?.isEmpty ?? true ? "Required" : null),
            const SizedBox(height: 16),
            ListTile(title: Text("Start: $_start"), trailing: const Icon(Icons.edit), onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _start, firstDate: DateTime(2025), lastDate: DateTime(2030));
              if (d != null) setState(() => _start = DateTime(d.year, d.month, d.day, _start.hour));
            }),
            ListTile(title: Text("End: $_end"), trailing: const Icon(Icons.edit), onTap: () async {
              final d = await showDatePicker(context: context, initialDate: _end, firstDate: DateTime(2025), lastDate: DateTime(2030));
              if (d != null) setState(() => _end = DateTime(d.year, d.month, d.day, _end.hour));
            }),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _saving ? null : _submit, child: _saving ? const CircularProgressIndicator() : const Text("Save Schedule")),
          ],
        ),
      ),
    );
  }
}