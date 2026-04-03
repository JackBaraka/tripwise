import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_spacing.dart';
import 'package:tripwise/app/theme/theme_mode_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeControllerProvider).value ?? ThemeMode.system;

    return ListView(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text('Settings', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SettingsHeader(
                  icon: PhosphorIcons.moonStars(PhosphorIconsStyle.fill),
                  title: 'Theme',
                  subtitle: 'Pick light, dark, or system.',
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<ThemeMode>(
                  segments: [
                    const ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                    ),
                    const ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                    ),
                    const ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (selection) {
                    ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(selection.first);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _SettingsHeader(
              icon: PhosphorIcons.bell(PhosphorIconsStyle.fill),
              title: 'Notifications',
              subtitle: 'Coming soon.',
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: scheme.primary.withAlpha(31),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: scheme.primary),
        ),
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

