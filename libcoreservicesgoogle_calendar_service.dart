import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/googleapis_auth.dart';
import '../constants/app_constants.dart';
import '../models/calendar_event.dart';

class GoogleCalendarService {
  AuthClient? _client;
  DateTime _lastRefresh = DateTime.now().subtract(Duration(seconds: AppConstants.refreshCooldownSec));

  Future<bool> init(AuthClient client) async {
    _client = client;
    return true;
  }

  bool get canRefresh => DateTime.now().difference(_lastRefresh).inSeconds >= AppConstants.refreshCooldownSec;

  Future<List<CalendarEvent>> fetchEvents(DateTime start, DateTime end) async {
    if (_client == null) return [];
    final calendar = cal.CalendarApi(_client!);
    final events = await calendar.events.list(
      AppConstants.calendarId,
      timeMin: start.toUtc(),
      timeMax: end.toUtc(),
      singleEvents: true,
      orderBy: 'startTime',
    );
    _lastRefresh = DateTime.now();

    return events.items?.map((e) => CalendarEvent(
      id: e.id ?? "",
      start: e.start?.dateTime ?? DateTime.tryParse(e.start?.date ?? "") ?? DateTime.now(),
      end: e.end?.dateTime ?? DateTime.tryParse(e.end?.date ?? "") ?? DateTime.now(),
      title: e.summary ?? "",
    )).toList() ?? [];
  }

  Future<String?> createEvent(CalendarEvent event) async {
    if (_client == null) return null;
    final calendar = cal.CalendarApi(_client!);
    final eventToCreate = cal.Event()
      ..summary = event.title
      ..start = cal.EventDateTime(dateTime: event.start.toUtc())
      ..end = cal.EventDateTime(dateTime: event.end.toUtc());
    final result = await calendar.events.insert(eventToCreate, AppConstants.calendarId);
    return result.id;
  }

  Future<void> deleteEvent(String eventId) async {
    if (_client == null) return;
    final calendar = cal.CalendarApi(_client!);
    await calendar.events.delete(AppConstants.calendarId, eventId);
  }
}