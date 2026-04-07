import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_colors.dart';
import 'package:tripwise/app/design/app_spacing.dart';
import 'package:tripwise/app/theme/theme_mode_controller.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  int _indexForLocation(String location) {
    if (location.startsWith('/fuel-cost')) return 1;
    if (location.startsWith('/trips')) return 2;
    if (location.startsWith('/budget')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  String _locationForIndex(int index) {
    return switch (index) {
      1 => '/fuel-cost',
      2 => '/trips',
      3 => '/settings',
      _ => '/',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexForLocation(location);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: child,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: NavigationBar(
              selectedIndex: index,
              height: 68,
              backgroundColor: scheme.surface,
              indicatorColor: AppColors.accent.withAlpha(36),
              onDestinationSelected: (i) => context.go(_locationForIndex(i)),
              destinations: [
                NavigationDestination(
                  icon: Icon(PhosphorIcons.house(PhosphorIconsStyle.regular)),
                  selectedIcon:
                      Icon(PhosphorIcons.house(PhosphorIconsStyle.fill)),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(PhosphorIcons.gasPump(PhosphorIconsStyle.regular)),
                  selectedIcon:
                      Icon(PhosphorIcons.gasPump(PhosphorIconsStyle.fill)),
                  label: 'Calculator',
                ),
                NavigationDestination(
                  icon: Icon(PhosphorIcons.mapTrifold(PhosphorIconsStyle.regular)),
                  selectedIcon:
                      Icon(PhosphorIcons.mapTrifold(PhosphorIconsStyle.fill)),
                  label: 'Trips',
                ),
                NavigationDestination(
                  icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.regular)),
                  selectedIcon:
                      Icon(PhosphorIcons.gear(PhosphorIconsStyle.fill)),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/trips'),
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              icon: Icon(PhosphorIcons.mapTrifold(PhosphorIconsStyle.fill)),
              label: const Text('My Trips'),
            )
          : null,
      appBar: AppBar(
        title: const Text('TripWise'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () => ref
                .read(themeModeControllerProvider.notifier)
                .toggleLightDark(),
            icon: Icon(PhosphorIcons.moonStars(PhosphorIconsStyle.regular)),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
    );
  }
}

