import 'package:adhan/adhan.dart';

/// Central place for user-configurable settings.
/// Add new fields here as you add features (e.g. Quran reciter, theme, etc.)
class PrayerSettings {
  double latitude;
  double longitude;
  String locationLabel;
  CalculationMethod calculationMethod;
  Madhab madhab;
  bool azanEnabled;

  PrayerSettings({
    required this.latitude,
    required this.longitude,
    required this.locationLabel,
    this.calculationMethod = CalculationMethod.muslim_world_league,
    this.madhab = Madhab.shafi,
    this.azanEnabled = true,
  });

  PrayerSettings copyWith({
    double? latitude,
    double? longitude,
    String? locationLabel,
    CalculationMethod? calculationMethod,
    Madhab? madhab,
    bool? azanEnabled,
  }) {
    return PrayerSettings(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationLabel: locationLabel ?? this.locationLabel,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      azanEnabled: azanEnabled ?? this.azanEnabled,
    );
  }
}
