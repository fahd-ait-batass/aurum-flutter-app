import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class RestaurantShowcaseCard extends StatelessWidget {
  const RestaurantShowcaseCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
    this.height = 186,
  });

  final Restaurant restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      radius: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: height,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: restaurant.gradientColors,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 4,
                  bottom: -6,
                  child: Icon(
                    restaurant.heroIcon,
                    size: 88,
                    color: const Color(0xFFF8F1E7).withValues(alpha: 0.82),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StatusChip(
                      label: restaurant.badgeLabel,
                      backgroundColor: const Color(0x29151821),
                      foregroundColor: const Color(0xFFF6C56B),
                      borderColor: const Color(0x554A3422),
                    ),
                    const Spacer(),
                    if (onFavoriteTap != null)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton.filledTonal(
                          onPressed: onFavoriteTap,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0x33151821),
                            foregroundColor: isFavorite
                                ? const Color(0xFFFF8B5C)
                                : const Color(0xFFF8F1E7),
                          ),
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  restaurant.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  '${restaurant.cuisine} | ${restaurant.neighborhood}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFFF6C56B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  restaurant.moodLine,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: <Widget>[
                    _MetaRow(
                      icon: Icons.star_rounded,
                      label: restaurant.rating.toStringAsFixed(1),
                    ),
                    _MetaRow(
                      icon: Icons.sell_rounded,
                      label: restaurant.priceTier,
                    ),
                    _MetaRow(
                      icon: Icons.place_rounded,
                      label: restaurant.distanceLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16, color: const Color(0xFFF6C56B)),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
