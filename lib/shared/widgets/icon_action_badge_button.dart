import 'package:flutter/material.dart';

class IconActionBadgeButton extends StatelessWidget {
  const IconActionBadgeButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.count = 0,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final int count;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF171B23),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A303A)),
            ),
            child: IconButton(
              onPressed: onPressed,
              tooltip: tooltip,
              icon: Icon(icon, size: 20),
            ),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFF0B0D12), width: 2),
                ),
                child: Center(
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF221507),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
