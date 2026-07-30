import 'package:flutter/material.dart';

import '../models/prayer_settings.dart';
import 'calendar_screen.dart';
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'settings_screen.dart';

/// Owns the shared PrayerSettings and hosts the bottom navigation.
///
/// TO ADD A NEW FEATURE (e.g. Tasbih Counter, Quran):
///   1. Create lib/screens/your_feature_screen.dart
///   2. Import it above
///   3. Add it to `_screens` and add a matching item to `_navItems` below
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // Default location: Toronto, ON. User can override via "use my location".
  PrayerSettings _settings = PrayerSettings(
    latitude: 43.6532,
    longitude: -79.3832,
    locationLabel: 'Toronto, ON (default — tap the location icon to update)',
  );

  void _updateSettings(PrayerSettings updated) {
    setState(() => _settings = updated);
  }

  List<Widget> get _screens => [
        PrayerTimesScreen(
          settings: _settings,
          onSettingsChanged: _updateSettings,
        ),
        QiblaScreen(settings: _settings),
        const CalendarScreen(),
        SettingsScreen(
          settings: _settings,
          onSettingsChanged: _updateSettings,
        ),
      ];

  static const _navItems = [
    NavigationDestination(icon: Icon(Icons.access_time), label: 'Prayers'),
    NavigationDestination(icon: Icon(Icons.explore), label: 'Qibla'),
    NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Calendar'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _navItems,
      ),
    );
  }
}
