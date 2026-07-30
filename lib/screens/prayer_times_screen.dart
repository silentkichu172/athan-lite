import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../models/prayer_settings.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/prayer_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  final PrayerSettings settings;
  final ValueChanged<PrayerSettings> onSettingsChanged;

  const PrayerTimesScreen({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  DailyPrayerTimes? _times;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final times = PrayerService.getTimesForDate(
        latitude: widget.settings.latitude,
        longitude: widget.settings.longitude,
        date: DateTime.now(),
        method: widget.settings.calculationMethod,
        madhab: widget.settings.madhab,
      );
      setState(() {
        _times = times;
        _loading = false;
      });
      if (widget.settings.azanEnabled) {
        await NotificationService.scheduleTodaysPrayers(times);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loading = true);
    try {
      final Position pos = await LocationService.getCurrentPosition();
      final updated = widget.settings.copyWith(
        latitude: pos.latitude,
        longitude: pos.longitude,
        locationLabel:
            '${pos.latitude.toStringAsFixed(3)}, ${pos.longitude.toStringAsFixed(3)}',
      );
      widget.onSettingsChanged(updated);
      await _load();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Use current location',
            onPressed: _useCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(_error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _useCurrentLocation,
            child: const Text('Grant location & retry'),
          ),
        ],
      );
    }
    final times = _times!;
    final next = times.nextPrayer();
    final timeFormat = DateFormat.jm();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.settings.locationLabel,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  next == null
                      ? 'All prayers done for today'
                      : 'Next: ${next.key} at ${timeFormat.format(next.value)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...times.asList().map((entry) {
          final isNext = next != null && entry.key == next.key;
          return Card(
            child: ListTile(
              leading: Icon(
                _iconFor(entry.key),
                color: isNext ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(entry.key),
              trailing: Text(
                timeFormat.format(entry.value),
                style: TextStyle(
                  fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  IconData _iconFor(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.light_mode;
      case 'Asr':
        return Icons.cloud_outlined;
      case 'Maghrib':
        return Icons.nights_stay_outlined;
      case 'Isha':
        return Icons.dark_mode;
      default:
        return Icons.access_time;
    }
  }
}
