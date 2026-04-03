import 'package:flutter/material.dart';

import 'package:tripwise/shared/widgets/app_scaffold.dart';

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
    return AppScaffold(
      title: 'Fuel cost',
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Trip fuel cost calculator',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _distanceKmController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Distance (km)',
                hintText: 'e.g. 250',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  _parsePositiveDouble(value) == null ? 'Enter a valid distance.' : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _consumptionKmPerLController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Fuel consumption (km/l)',
                hintText: 'e.g. 14.5',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _parsePositiveDouble(value) == null
                  ? 'Enter a valid consumption.'
                  : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fuelPricePerLController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Fuel price (per litre)',
                hintText: 'e.g. 1.65',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  _parsePositiveDouble(value) == null ? 'Enter a valid price.' : null,
              onFieldSubmitted: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _calculate,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 16),
            if (_fuelNeededL != null && _totalCost != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Results',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _ResultRow(
                        label: 'Fuel needed',
                        value: '${_fuelNeededL!.toStringAsFixed(2)} L',
                      ),
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: 'Total cost',
                        value: _totalCost!.toStringAsFixed(2),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

