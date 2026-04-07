import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripwise/features/trips/data/trip_model.dart';
import 'package:tripwise/features/trips/data/trips_repository.dart';

/// Repository provider
final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  return TripsRepository();
});

/// Trips list state
class TripsListState {
  final List<Trip> trips;
  final bool isLoading;
  final String? error;

  const TripsListState({
    this.trips = const [],
    this.isLoading = false,
    this.error,
  });

  TripsListState copyWith({
    List<Trip>? trips,
    bool? isLoading,
    String? error,
  }) {
    return TripsListState(
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Trips list notifier
class TripsListNotifier extends StateNotifier<TripsListState> {
  final TripsRepository _repository;

  TripsListNotifier(this._repository) : super(const TripsListState()) {
    loadTrips();
  }

  Future<void> loadTrips() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trips = await _repository.loadTrips();
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> saveTrip(Trip trip) async {
    try {
      await _repository.saveTrip(trip);
      await loadTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await _repository.deleteTrip(tripId);
      await loadTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Main trips provider
final tripsListProvider =
    StateNotifierProvider<TripsListNotifier, TripsListState>((ref) {
  final repository = ref.watch(tripsRepositoryProvider);
  return TripsListNotifier(repository);
});

/// Single trip provider by ID
final tripByIdProvider = Provider.family<Trip?, String>((ref, tripId) {
  final state = ref.watch(tripsListProvider);
  try {
    return state.trips.firstWhere((t) => t.id == tripId);
  } catch (_) {
    return null;
  }
});
