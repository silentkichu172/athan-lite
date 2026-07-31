import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../models/prayer_settings.dart';
import '../services/prayer_service.dart';

class QiblaScreen extends StatefulWidget {
  final PrayerSettings settings;

  const QiblaScreen({super.key, required this.settings});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _heading;
  StreamSubscription<CompassEvent>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = FlutterCompass.events?.listen((event) {
      setState(() => _heading = event.heading);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qibla = PrayerService.qiblaBearing(
      widget.settings.latitude,
      widget.settings.longitude,
    );

    if (_heading == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Qibla Finder')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Waiting for compass sensor...\n'
              'Move your phone in a figure-8 to calibrate if needed.\n'
              '(Compass is not available on emulators.)',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final angle = ((qibla - _heading!) * (3.1415926535 / 180));

    return Scaffold(
      appBar: AppBar(title: const Text('Qibla Finder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Qibla: ${qibla.toStringAsFixed(1)}°',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
              ),
              child: Transform.rotate(
                angle: angle,
                child: Icon(
                  Icons.navigation,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Hold your phone flat. The arrow points toward the Kaaba '
                'once it lines up with the top of the circle.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
