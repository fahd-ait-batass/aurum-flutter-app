import 'package:flutter/material.dart';
import 'package:flutter_app/features/home/data/home_seed_data.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.item, this.onTap});

  final QuickActionItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxHeight < 196;
        final double iconSize = compact ? 46 : 52;
        final double iconRadius = compact ? 16 : 18;
        final double topGap = compact ? 14 : 18;
        final int titleLines = compact ? 1 : 2;
        final int subtitleLines = compact ? 2 : 3;

        return SurfaceCard(
          onTap: onTap,
          padding: const EdgeInsets.all(18),
          backgroundColor: const Color(0xFF171B23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: item.accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(iconRadius),
                ),
                child: Icon(item.icon, color: item.accentColor),
              ),
              SizedBox(height: topGap),
              Text(
                item.title,
                maxLines: titleLines,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  item.subtitle,
                  maxLines: subtitleLines,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFFF6C56B),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
