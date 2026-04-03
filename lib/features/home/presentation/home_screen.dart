import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tripwise/shared/widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'TripWise',
      actions: [
        IconButton(
          tooltip: 'Settings',
          onPressed: () => context.go('/settings'),
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan smarter trips.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Starter app wired with Material 3, go_router, and Riverpod.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/fuel-cost'),
            icon: const Icon(Icons.local_gas_station_outlined),
            label: const Text('Fuel cost calculator'),
          ),
        ],
      ),
    );
  }
}

