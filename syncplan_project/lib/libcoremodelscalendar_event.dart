class CalendarEvent {
  final String id;
  final DateTime start;
  final DateTime end;
  final String title;

  CalendarEvent({required this.id, required this.start, required this.end, required this.title});

  // 解析后的类型数据
  Map<String, dynamic>? parsedData;
}