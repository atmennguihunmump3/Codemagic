import 'package:flutter/material.dart';
import '../../core/utils/permission_helper.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/syntax_parser.dart';
import '../../core/models/calendar_event.dart';
import '../../core/services/google_calendar_service.dart';
import 'delivery_form_screen.dart';
import 'widgets/timeline_card.dart';

class DeliveryScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  final DateTime selectedDate;
  const DeliveryScreen({super.key, required this.accessLevel, required this.selectedDate});
  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  List<CalendarEvent> _events = [];
  bool _loading = false;
  final _service = GoogleCalendarService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!_service.canRefresh) return;
    setState(() => _loading = true);
    final start = DateHelper.startOfWeek(widget.selectedDate);
    final end = DateHelper.endOfWeek(widget.selectedDate);
    final raw = await _service.fetchEvents(start, end);
    setState(() {
      _events = raw.where((e) => e.title.trim().startsWith("D#")).toList();
      _loading = false;
    });
  }

  Map<DateTime, List<CalendarEvent>> get grouped {
    Map<DateTime, List<CalendarEvent>> map = {};
    for (final e in _events) {
      final day = DateTime(e.start.year, e.start.month, e.start.day);
      map.putIfAbsent(day, () => []).add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PermissionHelper.canAdd(widget.accessLevel)
          ? FloatingActionButton(child: const Icon(Icons.add), onPressed: () => _openForm(context))
          : null,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: grouped.entries.map((entry) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(DateHelper.formatDisplay(entry.key), style: const TextStyle(fontWeight: FontWeight.bold))),
                    ...entry.value.map((e) => TimelineCard(event: e, data: SyntaxParser.parse(e.title)!)).toList(),
                  ]);
                }).toList(),
              ),
      ),
    );
  }

  void _openForm(BuildContext ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => DeliveryFormScreen(accessLevel: widget.accessLevel, initialDate: widget.selectedDate))).then((_) => _loadData());
  }
}