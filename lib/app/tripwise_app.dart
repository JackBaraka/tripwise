import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class TripwiseApp extends StatelessWidget {
  const TripwiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = appRouter();

    return MaterialApp.router(
      title: 'TripWise',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

