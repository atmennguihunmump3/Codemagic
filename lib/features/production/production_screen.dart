import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/permission_helper.dart';
import '../../core/utils/date_helper.dart';
import '../../core/utils/syntax_parser.dart';
import '../../core/models/calendar_event.dart';
import '../../core/services/google_calendar_service.dart';
import 'production_form_screen.dart';
import 'widgets/gantt_chart.dart';

class ProductionScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  final DateTime selectedDate;
  const ProductionScreen({super.key, required this.accessLevel, required this.selectedDate});
  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
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
    final start = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);
    final end = start.add(const Duration(days: AppConstants.productionViewDays));
    final raw = await _service.fetchEvents(start, end);
    setState(() {
      _events = raw.where((e) => e.title.trim().startsWith("P#")).map((e) {
        e.parsedData = SyntaxParser.parse(e.title);
        return e;
      }).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PermissionHelper.canAdd(widget.accessLevel)
          ? FloatingActionButton(child: const Icon(Icons.add), onPressed: _openForm)
          : null,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: GanttChart(events: _events, baseDate: DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day)),
              ),
      ),
    );
  }

  void _openForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductionFormScreen(accessLevel: widget.accessLevel, initialDate: widget.selectedDate))).then((_) => _loadData());
  }
}