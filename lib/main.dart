import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/auth_service.dart';
import 'core/themes/app_theme.dart';
import 'routes.dart';
import 'shared/widgets/pin_entry_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthService();
  final level = await auth.initialize();
  runApp(SyncPlanApp(auth: auth, initialAccess: level));
}

class SyncPlanApp extends StatelessWidget {
  final AuthService auth;
  final AccessLevel initialAccess;
  const SyncPlanApp({super.key, required this.auth, required this.initialAccess});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyncPlan',
      theme: AppTheme.light,
      home: initialAccess == AccessLevel.viewer
          ? PinEntryScreen(auth: auth)
          : MainTabsScreen(accessLevel: initialAccess),
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings, initialAccess),
    );
  }
}

class MainTabsScreen extends StatefulWidget {
  final AccessLevel accessLevel;
  const MainTabsScreen({super.key, required this.accessLevel});
  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedTab = 0;
  DateTime _selectedDate = DateTime.now();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SES Polymer Planning Schedule"),
        actions: [IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate)],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _selectedTab = i),
        children: [
          HomeScreen(accessLevel: widget.accessLevel, selectedDate: _selectedDate),
          DeliveryScreen(accessLevel: widget.accessLevel, selectedDate: _selectedDate),
          ProductionScreen(accessLevel: widget.accessLevel, selectedDate: _selectedDate),
          AttendanceScreen(accessLevel: widget.accessLevel, selectedDate: _selectedDate),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: "Delivery"),
          BottomNavigationBarItem(icon: Icon(Icons.factory), label: "Production"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Attendance"),
        ],
        onTap: (i) => setState(() {
          _selectedTab = i;
          _pageController.animateToPage(i, duration: const Duration(milliseconds: 200), curve: Curves.ease);
        }),
      ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }
}