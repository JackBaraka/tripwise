import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_spacing.dart';
import 'package:tripwise/shared/providers/trips_provider.dart';

class BudgetScreen extends ConsumerWidget {
  final String tripId;

  const BudgetScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripByIdProvider(tripId));

    if (trip == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Trip not found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            trip.name,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Cost breakdown for your trip.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.navigationArrow(PhosphorIconsStyle.regular),
                        color: scheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${trip.distanceKm.toStringAsFixed(0)} km',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Icon(
                        PhosphorIcons.gauge(PhosphorIconsStyle.regular),
                        color: scheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${trip.consumptionKmPerL.toStringAsFixed(1)} km/l',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Budget',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: scheme.onPrimaryContainer,
                              ),
                        ),
                        Text(
                          '\$${trip.totalCost.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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

          const SizedBox(height: AppSpacing.md),

          // Cost Breakdown
          Text(
            'Cost Breakdown',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),

          _CostItem(
            icon: PhosphorIcons.gasPump(PhosphorIconsStyle.fill),
            label: 'Fuel',
            amount: trip.fuelCost,
            percentage: (trip.fuelCost / trip.totalCost * 100),
            color: scheme.primary,
          ),

          if (trip.tollsCost != null && trip.tollsCost! > 0)
            _CostItem(
              icon: PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
              label: 'Tolls',
              amount: trip.tollsCost!,
              percentage: (trip.tollsCost! / trip.totalCost * 100),
              color: Colors.orange,
            ),

          if (trip.foodCost != null && trip.foodCost! > 0)
            _CostItem(
              icon: PhosphorIcons.forkKnife(PhosphorIconsStyle.fill),
              label: 'Food',
              amount: trip.foodCost!,
              percentage: (trip.foodCost! / trip.totalCost * 100),
              color: Colors.green,
            ),

          if (trip.lodgingCost != null && trip.lodgingCost! > 0)
            _CostItem(
              icon: PhosphorIcons.bed(PhosphorIconsStyle.fill),
              label: 'Lodging',
              amount: trip.lodgingCost!,
              percentage: (trip.lodgingCost! / trip.totalCost * 100),
              color: Colors.purple,
            ),

          const SizedBox(height: AppSpacing.lg),

          // Per Person / Daily estimates could go here
          Card(
            color: scheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.lightbulb(PhosphorIconsStyle.fill),
                        color: scheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Tips',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '• Fuel is your largest expense at ${(trip.fuelCost / trip.totalCost * 100).toStringAsFixed(0)}% of total costs.\n'
                    '• Consider splitting tolls with travel companions.\n'
                    '• Food costs can vary widely—plan accordingly.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _CostItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final double percentage;
  final Color color;

  const _CostItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withAlpha(31),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}% of total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: scheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
