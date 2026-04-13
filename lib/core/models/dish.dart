import 'package:flutter/material.dart';

class Dish {
  const Dish({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.priceMad,
    required this.rating,
    required this.prepMinutes,
    required this.calories,
    required this.badgeLabel,
    required this.heroIcon,
    required this.gradientColors,
    required this.ingredients,
    required this.dietaryNotes,
  });

  final String id;
  final String restaurantId;
  final String name;
  final String shortDescription;
  final String description;
  final double priceMad;
  final double rating;
  final int prepMinutes;
  final int calories;
  final String badgeLabel;
  final IconData heroIcon;
  final List<Color> gradientColors;
  final List<String> ingredients;
  final List<String> dietaryNotes;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'shortDescription': shortDescription,
      'description': description,
      'priceMad': priceMad,
      'rating': rating,
      'prepMinutes': prepMinutes,
      'calories': calories,
      'badgeLabel': badgeLabel,
      'heroIconCodePoint': heroIcon.codePoint,
      'gradientColors': gradientColors
          .map((Color color) => color.toARGB32())
          .toList(growable: false),
      'ingredients': ingredients,
      'dietaryNotes': dietaryNotes,
    };
  }

  factory Dish.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawGradientColors =
        json['gradientColors'] as List<dynamic>? ?? <dynamic>[];
    return Dish(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String,
      description: json['description'] as String,
      priceMad: (json['priceMad'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      prepMinutes: json['prepMinutes'] as int,
      calories: json['calories'] as int,
      badgeLabel: json['badgeLabel'] as String,
      heroIcon: IconData(
        json['heroIconCodePoint'] as int,
        fontFamily: 'MaterialIcons',
      ),
      gradientColors: rawGradientColors
          .map((dynamic color) => Color(color as int))
          .toList(growable: false),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      dietaryNotes: (json['dietaryNotes'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
    );
  }
}
