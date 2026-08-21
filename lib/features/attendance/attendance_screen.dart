import 'package:flutter/material.dart';
import '../../core/utils/permission_helper.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/syntax_parser.dart';
import '../../core/models/calendar_event.dart';
import '../../core/services/google_calendar_service.dart';
import 'attendance_form_screen.dart';
import 'widgets/calendar_cell.dart';

class AttendanceScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  final DateTime selectedDate;
  const AttendanceScreen({
    super.key,
    required this.accessLevel,
    required this.selectedDate,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<CalendarEvent> _events = [];
  bool _loading = false;
  late DateTime _month;
  final _service = GoogleCalendarService();

  @override
  void initState() {
    super.initState();
    _month = DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _loadData();
  }

  Future<void> _loadData() async {
    if (!_service.canRefresh) return;
    setState(() => _loading = true);
    final start = DateTime(_month.year, _month.month, 1);
    final end = DateTime(_month.year, _month.month + 1, 1);
    final raw = await _service.fetchEvents(start, end);
    setState(() {
      _events = raw.where((e) => e.title.trim().startsWith("A#")).map((e) {
        e.parsedData = SyntaxParser.parse(e.title);
        return e;
      }).toList();
      _loading = false;
    });
  }

  List<DateTime> _daysInMonth() {
    final first = DateTime(_month.year, _month.month, 1);
    final daysBefore = first.weekday - 1;
    final start = first.subtract(Duration(days: daysBefore));
    return List.generate(42, (i) => DateTime(start.year, start.month, start.day + i));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_month.month}/${_month.year}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _month = DateTime(_month.year, _month.month - 1);
            }),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _month = DateTime(_month.year, _month.month + 1);
            }),
          ),
        ],
      ),
      floatingActionButton: PermissionHelper.canAdd(widget.accessLevel)
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: _openForm,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Su"), Text("Mo"), Text("Tu"),
                        Text("We"), Text("Th"), Text("Fr"), Text("Sa"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: _daysInMonth().map((day) {
                          final dayEvents = _events
                              .where((e) => DateHelper.isSameDay(e.start, day))
                              .toList();
                          return CalendarCell(
                            day: day,
                            currentMonth: _month,
                            events: dayEvents,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, color: Color(0xFFE53935), size: 12),
                        SizedBox(width: 4),
                        Text("Absent"),
                        SizedBox(width: 16),
                        Icon(Icons.circle, color: Color(0xFF9C27B0), size: 12),
                        SizedBox(width: 4),
                        Text("Leave"),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendanceFormScreen(
          accessLevel: widget.accessLevel,
          initialDate: widget.selectedDate,
        ),
      ),
    ).then((_) => _loadData());
  }
}