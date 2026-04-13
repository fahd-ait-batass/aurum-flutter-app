import 'package:flutter/material.dart';

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.neighborhood,
    required this.priceTier,
    required this.description,
    required this.moodLine,
    required this.badgeLabel,
    required this.distanceLabel,
    required this.deliveryTimeLabel,
    required this.rating,
    required this.reviewCount,
    required this.heroIcon,
    required this.gradientColors,
    required this.categories,
    required this.highlights,
    required this.availableSlots,
    required this.featuredDishIds,
  });

  final String id;
  final String name;
  final String cuisine;
  final String neighborhood;
  final String priceTier;
  final String description;
  final String moodLine;
  final String badgeLabel;
  final String distanceLabel;
  final String deliveryTimeLabel;
  final double rating;
  final int reviewCount;
  final IconData heroIcon;
  final List<Color> gradientColors;
  final List<String> categories;
  final List<String> highlights;
  final List<String> availableSlots;
  final List<String> featuredDishIds;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'neighborhood': neighborhood,
      'priceTier': priceTier,
      'description': description,
      'moodLine': moodLine,
      'badgeLabel': badgeLabel,
      'distanceLabel': distanceLabel,
      'deliveryTimeLabel': deliveryTimeLabel,
      'rating': rating,
      'reviewCount': reviewCount,
      'heroIconCodePoint': heroIcon.codePoint,
      'gradientColors': gradientColors
          .map((Color color) => color.toARGB32())
          .toList(growable: false),
      'categories': categories,
      'highlights': highlights,
      'availableSlots': availableSlots,
      'featuredDishIds': featuredDishIds,
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawGradientColors =
        json['gradientColors'] as List<dynamic>? ?? <dynamic>[];
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      neighborhood: json['neighborhood'] as String,
      priceTier: json['priceTier'] as String,
      description: json['description'] as String,
      moodLine: json['moodLine'] as String,
      badgeLabel: json['badgeLabel'] as String,
      distanceLabel: json['distanceLabel'] as String,
      deliveryTimeLabel: json['deliveryTimeLabel'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      heroIcon: IconData(
        json['heroIconCodePoint'] as int,
        fontFamily: 'MaterialIcons',
      ),
      gradientColors: rawGradientColors
          .map((dynamic color) => Color(color as int))
          .toList(growable: false),
      categories: (json['categories'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      highlights: (json['highlights'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      availableSlots: (json['availableSlots'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
      featuredDishIds: (json['featuredDishIds'] as List<dynamic>)
          .map((dynamic item) => item as String)
          .toList(growable: false),
    );
  }
}
