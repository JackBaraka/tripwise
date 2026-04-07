import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_spacing.dart';
import 'package:tripwise/features/trips/data/trip_model.dart';
import 'package:tripwise/shared/providers/trips_provider.dart';

class FuelCostScreen extends ConsumerStatefulWidget {
  const FuelCostScreen({super.key});

  @override
  ConsumerState<FuelCostScreen> createState() => _FuelCostScreenState();
}

class _FuelCostScreenState extends ConsumerState<FuelCostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tripNameController = TextEditingController();
  final _distanceKmController = TextEditingController();
  final _consumptionKmPerLController = TextEditingController();
  final _fuelPricePerLController = TextEditingController();
  final _tollsController = TextEditingController();
  final _foodController = TextEditingController();
  final _lodgingController = TextEditingController();

  double? _fuelNeededL;
  double? _fuelCost;
  double? _totalCost;
  bool _showAdditionalCosts = false;

  @override
  void dispose() {
    _tripNameController.dispose();
    _distanceKmController.dispose();
    _consumptionKmPerLController.dispose();
    _fuelPricePerLController.dispose();
    _tollsController.dispose();
    _foodController.dispose();
    _lodgingController.dispose();
    super.dispose();
  }

  double? _parsePositiveDouble(String? raw) {
    final normalized = (raw ?? '').trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    final value = double.tryParse(normalized);
    if (value == null || value < 0) return null;
    return value;
  }

  void _calculate() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final distanceKm = _parsePositiveDouble(_distanceKmController.text)!;
    final consumptionKmPerL =
        _parsePositiveDouble(_consumptionKmPerLController.text)!;
    final pricePerL = _parsePositiveDouble(_fuelPricePerLController.text)!;
    final tolls = _parsePositiveDouble(_tollsController.text) ?? 0;
    final food = _parsePositiveDouble(_foodController.text) ?? 0;
    final lodging = _parsePositiveDouble(_lodgingController.text) ?? 0;

    final fuelNeededL = distanceKm / consumptionKmPerL;
    final fuelCost = fuelNeededL * pricePerL;
    final totalCost = fuelCost + tolls + food + lodging;

    setState(() {
      _fuelNeededL = fuelNeededL;
      _fuelCost = fuelCost;
      _totalCost = totalCost;
    });
  }

  Future<void> _saveTrip() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final trip = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _tripNameController.text.trim(),
      distanceKm: _parsePositiveDouble(_distanceKmController.text)!,
      consumptionKmPerL: _parsePositiveDouble(_consumptionKmPerLController.text)!,
      fuelPricePerL: _parsePositiveDouble(_fuelPricePerLController.text)!,
      tollsCost: _parsePositiveDouble(_tollsController.text),
      foodCost: _parsePositiveDouble(_foodController.text),
      lodgingCost: _parsePositiveDouble(_lodgingController.text),
      createdAt: DateTime.now(),
    );

    await ref.read(tripsListProvider.notifier).saveTrip(trip);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trip "${trip.name}" saved!')),
      );
      context.go('/trips');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text('Fuel cost', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Enter your trip details to estimate litres needed and total cost.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip Details',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _tripNameController,
                    decoration: InputDecoration(
                      labelText: 'Trip name',
                      hintText: 'e.g. Summer Road Trip',
                      prefixIcon: Icon(
                        PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a trip name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Inputs', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _distanceKmController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Distance (km)',
                      hintText: 'e.g. 250',
                      prefixIcon: Icon(
                        PhosphorIcons.roadHorizon(PhosphorIconsStyle.regular),
                      ),
                    ),
                    validator: (value) {
                      final parsed = _parsePositiveDouble(value);
                      if (parsed == null) {
                        return 'Enter a valid distance';
                      }
                      if (parsed < 1) {
                        return 'Distance must be at least 1 km';
                      }
                      if (parsed > 50000) {
                        return 'Distance cannot exceed 50,000 km';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _consumptionKmPerLController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Fuel consumption (km/l)',
                      hintText: 'e.g. 14.5',
                      prefixIcon: Icon(
                        PhosphorIcons.gauge(PhosphorIconsStyle.regular),
                      ),
                    ),
                    validator: (value) {
                      final parsed = _parsePositiveDouble(value);
                      if (parsed == null) {
                        return 'Enter a valid consumption';
                      }
                      if (parsed < 1) {
                        return 'Consumption must be at least 1 km/l';
                      }
                      if (parsed > 100) {
                        return 'Consumption cannot exceed 100 km/l';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _fuelPricePerLController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Fuel price (per litre)',
                      hintText: 'e.g. 1.65',
                      prefixIcon: Icon(
                        PhosphorIcons.currencyCircleDollar(
                          PhosphorIconsStyle.regular,
                        ),
                      ),
                    ),
                    validator: (value) {
                      final parsed = _parsePositiveDouble(value);
                      if (parsed == null) {
                        return 'Enter a valid price';
                      }
                      if (parsed < 0.01) {
                        return 'Price must be at least 0.01';
                      }
                      if (parsed > 20) {
                        return 'Price cannot exceed 20 per litre';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _calculate(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showAdditionalCosts = !_showAdditionalCosts),
                    icon: Icon(_showAdditionalCosts
                        ? PhosphorIcons.caretUp(PhosphorIconsStyle.regular)
                        : PhosphorIcons.caretDown(PhosphorIconsStyle.regular)),
                    label: Text(_showAdditionalCosts
                        ? 'Hide additional costs'
                        : 'Add tolls, food, lodging'),
                  ),
                  if (_showAdditionalCosts) ...[
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _tollsController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Tolls (optional)',
                        hintText: 'e.g. 25',
                        prefixIcon: Icon(
                          PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _foodController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Food (optional)',
                        hintText: 'e.g. 50',
                        prefixIcon: Icon(
                          PhosphorIcons.forkKnife(PhosphorIconsStyle.regular),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _lodgingController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Lodging (optional)',
                        hintText: 'e.g. 120',
                        prefixIcon: Icon(
                          PhosphorIcons.bed(PhosphorIconsStyle.regular),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.icon(
                    onPressed: _calculate,
                    icon: Icon(PhosphorIcons.equals(PhosphorIconsStyle.bold)),
                    label: const Text('Calculate'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: (_fuelNeededL != null && _totalCost != null)
                ? Card(
                    key: const ValueKey('results'),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Results',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _ResultRow(
                            label: 'Fuel needed',
                            value: '${_fuelNeededL!.toStringAsFixed(2)} L',
                            icon: PhosphorIcons.drop(PhosphorIconsStyle.fill),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _ResultRow(
                            label: 'Fuel cost',
                            value: '\$${_fuelCost!.toStringAsFixed(2)}',
                            icon: PhosphorIcons.gasPump(PhosphorIconsStyle.fill),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _ResultRow(
                            label: 'Total cost',
                            value: '\$${_totalCost!.toStringAsFixed(2)}',
                            icon: PhosphorIcons.receipt(PhosphorIconsStyle.fill),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _saveTrip,
                              icon: Icon(PhosphorIcons.floppyDisk(PhosphorIconsStyle.bold)),
                              label: const Text('Save Trip'),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Divider(color: scheme.outlineVariant.withAlpha(153)),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Tip: Add tolls, food, and lodging to see a full budget breakdown.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                : Card(
                    key: const ValueKey('empty'),
                    color: scheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: scheme.primary.withAlpha(31),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                              color: scheme.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Fill the inputs and tap Calculate to see results.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: scheme.primary.withAlpha(31),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: scheme.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

