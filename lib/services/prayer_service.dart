import 'dart:math' as math;
import 'package:adhan/adhan.dart';

class DailyPrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  DailyPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  List<MapEntry<String, DateTime>> asList() => [
        MapEntry('Fajr', fajr),
        MapEntry('Sunrise', sunrise),
        MapEntry('Dhuhr', dhuhr),
        MapEntry('Asr', asr),
        MapEntry('Maghrib', maghrib),
        MapEntry('Isha', isha),
      ];

  MapEntry<String, DateTime>? nextPrayer() {
    final now = DateTime.now();
    final salahOnly = asList().where((e) => e.key != 'Sunrise').toList();
    for (final entry in salahOnly) {
      if (entry.value.isAfter(now)) return entry;
    }
    return null;
  }
}

class PrayerService {
  static DailyPrayerTimes getTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    CalculationMethod method = CalculationMethod.muslim_world_league,
    Madhab madhab = Madhab.shafi,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = method.getParameters();
    params.madhab = madhab;

    final components = DateComponents(date.year, date.month, date.day);
    final prayerTimes = PrayerTimes(coordinates, components, params);

    return DailyPrayerTimes(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
    );
  }

  static double qiblaBearing(double latitude, double longitude) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;

    final lat1 = _degToRad(latitude);
    final lng1 = _degToRad(longitude);
    final lat2 = _degToRad(kaabaLat);
    final lng2 = _degToRad(kaabaLng);

    final dLng = lng2 - lng1;
    final y = math.sin(dLng) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    final bearing = math.atan2(y, x);

    return (_radToDeg(bearing) + 360) % 360;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180);
  static double _radToDeg(double rad) => rad * (180 / math.pi);
}
