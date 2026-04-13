import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class DishShowcaseCard extends StatelessWidget {
  const DishShowcaseCard({
    super.key,
    required this.dish,
    required this.restaurantName,
    this.onTap,
    this.onFavoriteTap,
    this.onAddTap,
    this.isFavorite = false,
    this.width,
  });

  final Dish dish;
  final String restaurantName;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddTap;
  final bool isFavorite;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool boundedHeight = constraints.maxHeight.isFinite;
          final bool compact = boundedHeight && constraints.maxHeight < 344;
          final double heroHeight = compact ? 124 : 140;
          final EdgeInsets badgePadding = compact
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

          Widget buildBody({required bool flexible}) {
            final Widget description = Text(
              dish.shortDescription,
              maxLines: flexible ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            );

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    dish.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    restaurantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFF6C56B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (flexible) Expanded(child: description) else description,
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: <Widget>[
                      _MetaLabel(
                        label: dish.rating.toStringAsFixed(1),
                        icon: Icons.star_rounded,
                      ),
                      _MetaLabel(
                        label: '${dish.prepMinutes} min',
                        icon: Icons.schedule_rounded,
                      ),
                      _MetaLabel(
                        label: '${dish.calories} cal',
                        icon: Icons.bolt_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          AppFormatters.currencyMad(dish.priceMad),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: const Color(0xFFF8F1E7)),
                        ),
                      ),
                      if (onAddTap != null) ...<Widget>[
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: onAddTap,
                          child: const Text('Add'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }

          final Widget topSection = Container(
            height: heroHeight,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dish.gradientColors,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: StatusChip(
                        label: dish.badgeLabel,
                        padding: badgePadding,
                        backgroundColor: const Color(0x29151821),
                        foregroundColor: const Color(0xFFF6C56B),
                        borderColor: const Color(0x554A3422),
                      ),
                    ),
                    const Spacer(),
                    if (onFavoriteTap != null)
                      IconButton.filledTonal(
                        onPressed: onFavoriteTap,
                        style: IconButton.styleFrom(
                          visualDensity: compact
                              ? VisualDensity.compact
                              : VisualDensity.standard,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: compact ? const Size(40, 40) : null,
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
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    dish.heroIcon,
                    size: compact ? 66 : 74,
                    color: const Color(0xFFF8F1E7).withValues(alpha: 0.86),
                  ),
                ),
              ],
            ),
          );

          return SurfaceCard(
            onTap: onTap,
            padding: EdgeInsets.zero,
            radius: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                topSection,
                if (boundedHeight)
                  Expanded(child: buildBody(flexible: true))
                else
                  buildBody(flexible: false),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetaLabel extends StatelessWidget {
  const _MetaLabel({required this.label, required this.icon});

  final String label;
  final IconData icon;

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
