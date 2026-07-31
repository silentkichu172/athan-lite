import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.fromDate(_selected);

    return Scaffold(
      appBar: AppBar(title: const Text('Islamic Calendar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    DateFormat.yMMMMEEEEd().format(_selected),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Pick a different date'),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selected,
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _selected = picked);
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Tip: Hijri dates are calculated astronomically and can be '
                'off by a day from local moon-sighting announcements. '
                'This is normal and matches most calendar apps.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
