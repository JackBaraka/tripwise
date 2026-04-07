import 'dart:convert';

class Trip {
  final String id;
  final String name;
  final double distanceKm;
  final double consumptionKmPerL;
  final double fuelPricePerL;
  final double? tollsCost;
  final double? foodCost;
  final double? lodgingCost;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.consumptionKmPerL,
    required this.fuelPricePerL,
    this.tollsCost,
    this.foodCost,
    this.lodgingCost,
    required this.createdAt,
  });

  double get fuelNeededL => distanceKm / consumptionKmPerL;
  double get fuelCost => fuelNeededL * fuelPricePerL;
  double get totalCost =>
      fuelCost + (tollsCost ?? 0) + (foodCost ?? 0) + (lodgingCost ?? 0);

  Trip copyWith({
    String? id,
    String? name,
    double? distanceKm,
    double? consumptionKmPerL,
    double? fuelPricePerL,
    double? tollsCost,
    double? foodCost,
    double? lodgingCost,
    DateTime? createdAt,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      distanceKm: distanceKm ?? this.distanceKm,
      consumptionKmPerL: consumptionKmPerL ?? this.consumptionKmPerL,
      fuelPricePerL: fuelPricePerL ?? this.fuelPricePerL,
      tollsCost: tollsCost ?? this.tollsCost,
      foodCost: foodCost ?? this.foodCost,
      lodgingCost: lodgingCost ?? this.lodgingCost,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'distanceKm': distanceKm,
      'consumptionKmPerL': consumptionKmPerL,
      'fuelPricePerL': fuelPricePerL,
      'tollsCost': tollsCost,
      'foodCost': foodCost,
      'lodgingCost': lodgingCost,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      name: json['name'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      consumptionKmPerL: (json['consumptionKmPerL'] as num).toDouble(),
      fuelPricePerL: (json['fuelPricePerL'] as num).toDouble(),
      tollsCost: (json['tollsCost'] as num?)?.toDouble(),
      foodCost: (json['foodCost'] as num?)?.toDouble(),
      lodgingCost: (json['lodgingCost'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Trip.fromJsonString(String jsonString) {
    return Trip.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
