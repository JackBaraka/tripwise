import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tripwise/app/tripwise_app.dart';

void main() {
  runApp(const ProviderScope(child: TripwiseApp()));
}
