import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      body: ListView(
        children: const [
          _SettingsTile(
            title: 'Theme',
            subtitle: 'Follows system by default.',
          ),
          _SettingsTile(
            title: 'Notifications',
            subtitle: 'Coming soon.',
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

