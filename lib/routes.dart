import 'package:flutter/material.dart';
import 'core/utils/permission_helper.dart';
import 'features/home/home_screen.dart';
import 'features/delivery/delivery_screen.dart';
import 'features/production/production_screen.dart';
import 'features/attendance/attendance_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings, AccessLevel accessLevel) {
    final args = settings.arguments as Map?;
    final selectedDate = args?['selectedDate'] as DateTime?;
    return MaterialPageRoute(
      builder: (_) {
        switch (settings.name) {
          case '/':
            return HomeScreen(accessLevel: accessLevel, selectedDate: selectedDate);
          case '/delivery':
            return DeliveryScreen(accessLevel: accessLevel, selectedDate: selectedDate);
          case '/production':
            return ProductionScreen(accessLevel: accessLevel, selectedDate: selectedDate);
          case '/attendance':
            return AttendanceScreen(accessLevel: accessLevel, selectedDate: selectedDate);
          default:
            return HomeScreen(accessLevel: accessLevel, selectedDate: selectedDate);
        }
      },
    );
  }
}