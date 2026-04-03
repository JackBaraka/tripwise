import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsThemeModeKey = 'theme_mode';

final themeModeControllerProvider =
    AsyncNotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsThemeModeKey);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsThemeModeKey, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }

  Future<void> toggleLightDark() async {
    final current = state.value ?? ThemeMode.system;
    final next = switch (current) {
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.dark,
    };
    await setThemeMode(next);
  }
}

