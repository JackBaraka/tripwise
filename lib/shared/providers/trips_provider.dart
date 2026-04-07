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

/// Trips list notifier using Riverpod 3.x Notifier
class TripsListNotifier extends Notifier<TripsListState> {
  @override
  TripsListState build() {
    _loadTrips();
    return const TripsListState();
  }

  Future<void> _loadTrips() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(tripsRepositoryProvider);
      final trips = await repository.loadTrips();
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadTrips() async {
    await _loadTrips();
  }

  Future<void> saveTrip(Trip trip) async {
    try {
      final repository = ref.read(tripsRepositoryProvider);
      await repository.saveTrip(trip);
      await _loadTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      final repository = ref.read(tripsRepositoryProvider);
      await repository.deleteTrip(tripId);
      await _loadTrips();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

/// Main trips provider
final tripsListProvider =
    NotifierProvider<TripsListNotifier, TripsListState>(TripsListNotifier.new);

/// Single trip provider by ID
final tripByIdProvider = Provider.family<Trip?, String>((ref, tripId) {
  final state = ref.watch(tripsListProvider);
  try {
    return state.trips.firstWhere((t) => t.id == tripId);
  } catch (_) {
    return null;
  }
});
