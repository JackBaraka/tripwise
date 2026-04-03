import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:tripwise/app/design/app_spacing.dart';
 

class FuelCostScreen extends StatefulWidget {
  const FuelCostScreen({super.key});

  @override
  State<FuelCostScreen> createState() => _FuelCostScreenState();
}

class _FuelCostScreenState extends State<FuelCostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _distanceKmController = TextEditingController();
  final _consumptionKmPerLController = TextEditingController();
  final _fuelPricePerLController = TextEditingController();

  double? _fuelNeededL;
  double? _totalCost;

  @override
  void dispose() {
    _distanceKmController.dispose();
    _consumptionKmPerLController.dispose();
    _fuelPricePerLController.dispose();
    super.dispose();
  }

  double? _parsePositiveDouble(String? raw) {
    final normalized = (raw ?? '').trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    final value = double.tryParse(normalized);
    if (value == null || value <= 0) return null;
    return value;
  }

  void _calculate() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final distanceKm = _parsePositiveDouble(_distanceKmController.text)!;
    final consumptionKmPerL = _parsePositiveDouble(_consumptionKmPerLController.text)!;
    final pricePerL = _parsePositiveDouble(_fuelPricePerLController.text)!;

    final fuelNeededL = distanceKm / consumptionKmPerL;
    final totalCost = fuelNeededL * pricePerL;

    setState(() {
      _fuelNeededL = fuelNeededL;
      _totalCost = totalCost;
    });
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
                    validator: (value) => _parsePositiveDouble(value) == null
                        ? 'Enter a valid distance.'
                        : null,
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
                    validator: (value) => _parsePositiveDouble(value) == null
                        ? 'Enter a valid consumption.'
                        : null,
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
                    validator: (value) => _parsePositiveDouble(value) == null
                        ? 'Enter a valid price.'
                        : null,
                    onFieldSubmitted: (_) => _calculate(),
                  ),
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
                            label: 'Total cost',
                            value: _totalCost!.toStringAsFixed(2),
                            icon: PhosphorIcons.receipt(PhosphorIconsStyle.fill),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Divider(color: scheme.outlineVariant.withAlpha(153)),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Tip: Save your theme preference in Settings.',
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

