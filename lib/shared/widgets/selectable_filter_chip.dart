import 'package:flutter/material.dart';

class SelectableFilterChip extends StatelessWidget {
  const SelectableFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0x29F6B756) : const Color(0xFF171B23),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0x55F6B756) : const Color(0xFF2B313C),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                size: 14,
                color: selected ? const Color(0xFFF6C56B) : const Color(0xFFE8E0D5),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? const Color(0xFFF6C56B) : const Color(0xFFE8E0D5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
