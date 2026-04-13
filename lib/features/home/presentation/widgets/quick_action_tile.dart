import 'package:flutter/material.dart';
import 'package:flutter_app/features/home/data/home_seed_data.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({super.key, required this.item, this.onTap});

  final QuickActionItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      backgroundColor: const Color(0xFF171B23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(item.icon, color: item.accentColor),
          ),
          const SizedBox(height: 18),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              item.subtitle,
              maxLines: 3,
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
  }
}
