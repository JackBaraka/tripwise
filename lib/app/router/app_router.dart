import 'package:go_router/go_router.dart';

import 'package:tripwise/features/fuel_cost/presentation/fuel_cost_screen.dart';
import 'package:tripwise/features/home/presentation/home_screen.dart';
import 'package:tripwise/features/settings/presentation/settings_screen.dart';

GoRouter appRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/fuel-cost',
        name: 'fuel-cost',
        builder: (context, state) => const FuelCostScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
