import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

import '../models/prayer_settings.dart';

class SettingsScreen extends StatelessWidget {
  final PrayerSettings settings;
  final ValueChanged<PrayerSettings> onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Calculation Method',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<CalculationMethod>(
            isExpanded: true,
            value: settings.calculationMethod,
            items: const [
              DropdownMenuItem(
                value: CalculationMethod.muslim_world_league,
                child: Text('Muslim World League'),
              ),
              DropdownMenuItem(
                value: CalculationMethod.egyptian,
                child: Text('Egyptian General Authority'),
              ),
              DropdownMenuItem(
                value: CalculationMethod.karachi,
                child: Text('University of Islamic Sciences, Karachi'),
              ),
              DropdownMenuItem(
                value: CalculationMethod.umm_al_qura,
                child: Text('Umm al-Qura, Makkah'),
              ),
              DropdownMenuItem(
                value: CalculationMethod.north_america,
                child: Text('ISNA (North America)'),
              ),
              DropdownMenuItem(
                value: CalculationMethod.dubai,
                child: Text('Dubai'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onSettingsChanged(settings.copyWith(calculationMethod: value));
              }
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Madhab (affects Asr time)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<Madhab>(
            isExpanded: true,
            value: settings.madhab,
            items: const [
              DropdownMenuItem(value: Madhab.shafi, child: Text('Shafi (Standard)')),
              DropdownMenuItem(value: Madhab.hanafi, child: Text('Hanafi')),
            ],
            onChanged: (value) {
              if (value != null) {
                onSettingsChanged(settings.copyWith(madhab: value));
              }
            },
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Azan Notifications'),
            subtitle: const Text('Notify at each prayer time'),
            value: settings.azanEnabled,
            onChanged: (value) {
              onSettingsChanged(settings.copyWith(azanEnabled: value));
            },
          ),
          const Divider(height: 32),
          const Text(
            'This app has no ads, no in-app purchases, and no analytics. '
            'All prayer time and Qibla calculations happen on-device.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
