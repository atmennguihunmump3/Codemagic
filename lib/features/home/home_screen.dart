import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/utils/date_helper.dart';
import 'core/utils/syntax_parser.dart';
import 'core/utils/permission_helper.dart';
import 'core/models/calendar_event.dart';
import 'core/services/google_calendar_service.dart';
import 'widgets/delivery_card.dart';
import 'widgets/production_card.dart';
import 'widgets/attendance_badge.dart';

class HomeScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  final DateTime selectedDate;
  const HomeScreen({super.key, required this.accessLevel, required this.selectedDate});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CalendarEvent> _events = [];
  String _filter = "All";
  bool _loading = false;
  int _cooldown = 0;
  final _service = GoogleCalendarService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!_service.canRefresh) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data up-to-date. Please try again in $_cooldown seconds.")),
      );
      return;
    }
    setState(() => _loading = true);
    final start = DateHelper.startOfWeek(widget.selectedDate);
    final end = DateHelper.endOfWeek(widget.selectedDate);
    final raw = await _service.fetchEvents(start, end);
    setState(() {
      _events = raw;
      _loading = false;
    });
  }

  List<CalendarEvent> get _filtered {
    if (_filter == "All") return _events;
    final prefix = {"Delivery": "D#", "Production": "P#", "Attendance": "A#"}[_filter];
    return _events.where((e) => e.title.trim().startsWith(prefix!)).toList();
  }

  int get _weeklyAbsent {
    return _events.where((e) {
      final p = SyntaxParser.parse(e.title);
      return p?["type"] == "attendance" && p?["status"] == "Absent";
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: ["All", "Delivery", "Production", "Attendance"].map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: _filter == f,
                        onSelected: (_) => setState(() => _filter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) {
                    final ev = _filtered[i];
                    final data = SyntaxParser.parse(ev.title);
                    if (data?["type"] == "delivery") return DeliveryCard(event: ev, data: data!);
                    if (data?["type"] == "production") return ProductionCard(event: ev, data: data!);
                    if (data?["type"] == "attendance") return AttendanceBadge(data: data!);
                    return const SizedBox();
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppColors.primaryDark.withOpacity(0.05),
                child: Text("📊 Weekly Absence Analytics: $_weeklyAbsent Absences this week",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
    );
  }
}