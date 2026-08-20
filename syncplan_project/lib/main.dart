import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 验证本地访问码
  final accessLevel = await AuthService().initialize();
  runApp(SyncPlanApp(accessLevel: accessLevel));
}
