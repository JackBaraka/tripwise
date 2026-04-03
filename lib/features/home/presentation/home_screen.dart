import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Plan smarter trips.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Quick tools to estimate costs and plan your next route.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FeatureHeader(
                  icon: PhosphorIcons.gasPump(PhosphorIconsStyle.fill),
                  title: 'Fuel cost',
                  subtitle: 'Estimate litres needed and total cost.',
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/settings'),
                        child: const Text('Settings'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.go('/fuel-cost'),
                        child: const Text('Open calculator'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          color: scheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _IconPill(icon: PhosphorIcons.sparkle(PhosphorIconsStyle.fill)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Tip: Save your preferred theme in Settings.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _FeatureHeader extends StatelessWidget {
  const _FeatureHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconPill(icon: icon),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconPill extends StatelessWidget {
  const _IconPill({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.primary.withAlpha(31),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: scheme.primary),
    );
  }
}

