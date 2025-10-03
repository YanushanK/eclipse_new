import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Model for address data
class AddressData {
  final String street;
  final String city;
  final String postalCode;
  final String country;

  AddressData({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  AddressData.empty()
      : street = '',
        city = '',
        postalCode = '',
        country = '';
}

/// Service for handling location and geocoding
class LocationService {
  /// Checks if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Checks and requests location permissions
  Future<LocationPermission> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Gets current position (foreground only)
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      final permission = await checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      // Get position with timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print('Error getting position: $e');
      return null;
    }
  }

  /// Converts coordinates to human-readable address
  Future<AddressData?> getAddressFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) return null;

      final place = placemarks.first;

      return AddressData(
        street: '${place.street ?? place.thoroughfare ?? ''}',
        city: place.locality ?? '',
        postalCode: place.postalCode ?? '',
        country: place.country ?? '',
      );
    } catch (e) {
      print('Error geocoding: $e');
      return null;
    }
  }

  /// Convenience method: Get current location and convert to address
  Future<AddressData?> getCurrentAddress() async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    return await getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );
  }
}