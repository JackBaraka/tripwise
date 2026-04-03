import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripwise/app/router/app_router.dart';
import 'package:tripwise/app/theme/app_theme.dart';
import 'package:tripwise/app/theme/theme_mode_controller.dart';

class TripwiseApp extends ConsumerWidget {
  const TripwiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = appRouter();
    final themeMode = ref.watch(themeModeControllerProvider).value ?? ThemeMode.system;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: MaterialApp.router(
        key: ValueKey(themeMode),
        title: 'TripWise',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }
}

