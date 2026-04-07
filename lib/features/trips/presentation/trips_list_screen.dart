import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_spacing.dart';
import 'package:tripwise/features/trips/data/trip_model.dart';
import 'package:tripwise/shared/providers/trips_provider.dart';
import 'package:tripwise/shared/utils/currency_formatter.dart';

class TripsListScreen extends ConsumerWidget {
  const TripsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripsListProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
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
            _buildContent(context, ref, tripsState),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/fuel-cost'),
        child: Icon(PhosphorIcons.plus()),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TripsListState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          children: [
            Icon(
              PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load trips',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton.tonal(
              onPressed: () => ref.read(tripsListProvider.notifier).loadTrips(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final trips = state.trips;

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
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => context.go('/fuel-cost'),
                icon: Icon(PhosphorIcons.plus()),
                label: const Text('Plan a Trip'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: trips.map((trip) => _TripCard(
        key: ValueKey(trip.id),
        trip: trip,
        onTap: () => context.go('/budget/${trip.id}'),
        onDelete: () => _showDeleteDialog(context, ref, trip),
      )).toList(),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Trip trip) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(tripsListProvider.notifier).deleteTrip(trip.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TripCard({
    super.key,
    required this.trip,
    required this.onTap,
    required this.onDelete,
  });

  String get _formatCurrency => CurrencyFormatter.formatKES(trip.totalCost);

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
                      _formatCurrency,
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
