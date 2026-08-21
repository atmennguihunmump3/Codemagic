class CalendarEvent {
  final String id;
  final DateTime start;
  final DateTime end;
  final String title;
  Map<String, dynamic>? parsedData;

  CalendarEvent({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
    this.parsedData,
  });
}