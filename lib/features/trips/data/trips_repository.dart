import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripwise/features/trips/data/trip_model.dart';

class TripsRepository {
  static const String _storageKey = 'saved_trips';

  Future<List<Trip>> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final tripsJson = prefs.getStringList(_storageKey) ?? [];
    return tripsJson.map((json) => Trip.fromJsonString(json)).toList();
  }

  Future<void> saveTrip(Trip trip) async {
    final trips = await loadTrips();
    final existingIndex = trips.indexWhere((t) => t.id == trip.id);
    if (existingIndex >= 0) {
      trips[existingIndex] = trip;
    } else {
      trips.insert(0, trip);
    }
    await _persistTrips(trips);
  }

  Future<void> deleteTrip(String tripId) async {
    final trips = await loadTrips();
    trips.removeWhere((t) => t.id == tripId);
    await _persistTrips(trips);
  }

  Future<void> _persistTrips(List<Trip> trips) async {
    final prefs = await SharedPreferences.getInstance();
    final tripsJson = trips.map((t) => t.toJsonString()).toList();
    await prefs.setStringList(_storageKey, tripsJson);
  }
}
