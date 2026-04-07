import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_spacing.dart';
import 'package:tripwise/features/trips/data/trip_model.dart';
import 'package:tripwise/features/trips/data/trips_repository.dart';

class TripsListScreen extends StatefulWidget {
  const TripsListScreen({super.key});

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  final _repository = TripsRepository();
  late Future<List<Trip>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  void _loadTrips() {
    _tripsFuture = _repository.loadTrips();
  }

  Future<void> _deleteTrip(Trip trip) async {
    await _repository.deleteTrip(trip.id);
    _loadTrips();
    if (mounted) setState(() {});
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Trip>>(
          future: _tripsFuture,
          builder: (context, snapshot) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Saved Trips',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your saved trip plans.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildContent(snapshot),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/fuel-cost'),
        child: Icon(PhosphorIcons.plus()),
      ),
    );
  }

  Widget _buildContent(AsyncSnapshot<List<Trip>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final trips = snapshot.data ?? [];

    if (trips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Icon(
                PhosphorIcons.mapTrifold(PhosphorIconsStyle.light),
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No saved trips yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Create a trip in the Fuel Cost calculator to get started.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: trips.map((trip) => _TripCard(
        trip: trip,
        onTap: () => context.go('/budget/${trip.id}'),
        onDelete: () => _deleteTrip(trip),
        formatCurrency: _formatCurrency,
      )).toList(),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String Function(double) formatCurrency;

  const _TripCard({
    required this.trip,
    required this.onTap,
    required this.onDelete,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.trash(PhosphorIconsStyle.regular),
                      color: scheme.error,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _InfoChip(
                    icon: PhosphorIcons.navigationArrow(PhosphorIconsStyle.regular),
                    label: '${trip.distanceKm.toStringAsFixed(0)} km',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _InfoChip(
                    icon: PhosphorIcons.gasPump(PhosphorIconsStyle.regular),
                    label: '${trip.fuelNeededL.toStringAsFixed(1)} L',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total estimated cost',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      formatCurrency(trip.totalCost),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
