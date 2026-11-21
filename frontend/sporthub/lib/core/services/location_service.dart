import 'package:geolocator/geolocator.dart';

class UserLocationData {
  final double latitude;
  final double longitude;
  final String cityName;
  final bool isGpsActive;

  UserLocationData({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.isGpsActive,
  });
}

class LocationService {
  static Future<UserLocationData> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _defaultLocation(false, 'Lokasi HP Nonaktif');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _defaultLocation(false, 'Izin Lokasi Ditolak');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _defaultLocation(false, 'Izin Lokasi Diblokir');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final city = _detectNearestCity(position.latitude, position.longitude);

      return UserLocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: city,
        isGpsActive: true,
      );
    } catch (_) {
      return _defaultLocation(false, 'Surabaya (Default)');
    }
  }

  static double calculateDistanceKm(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    final meters = Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    return double.parse((meters / 1000).toStringAsFixed(1));
  }

  static String _detectNearestCity(double lat, double lng) {
    final cities = [
      {'name': 'Surabaya', 'lat': -7.2575, 'lng': 112.7521},
      {'name': 'Sidoarjo', 'lat': -7.4478, 'lng': 112.7183},
      {'name': 'Gresik', 'lat': -7.1566, 'lng': 112.6555},
      {'name': 'Malang', 'lat': -7.9666, 'lng': 112.6326},
      {'name': 'Jakarta', 'lat': -6.2088, 'lng': 106.8456},
      {'name': 'Bandung', 'lat': -6.9175, 'lng': 107.6191},
    ];

    String nearest = 'Sekitar Lokasimu';
    double minDistance = double.infinity;

    for (final city in cities) {
      final dist = Geolocator.distanceBetween(
        lat,
        lng,
        city['lat'] as double,
        city['lng'] as double,
      );
      if (dist < minDistance && dist <= 35000) {
        minDistance = dist;
        nearest = city['name'] as String;
      }
    }
    return nearest;
  }

  static UserLocationData _defaultLocation(bool active, String label) {
    return UserLocationData(
      latitude: -7.2891,
      longitude: 112.7344,
      cityName: label,
      isGpsActive: active,
    );
  }
}