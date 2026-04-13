import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class FeaturedExperienceCard extends StatelessWidget {
  const FeaturedExperienceCard({
    super.key,
    required this.restaurant,
    required this.onReserve,
  });

  final Restaurant restaurant;
  final VoidCallback onReserve;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      radius: 32,
      padding: const EdgeInsets.all(24),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: restaurant.gradientColors,
      ),
      borderColor: const Color(0xFF4A3422),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -10,
            top: 8,
            child: Icon(
              Icons.local_dining_rounded,
              size: 126,
              color: const Color(0xFFF6C56B).withValues(alpha: 0.16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const StatusChip(
                label: 'Tonight\'s signature',
                icon: Icons.auto_awesome_rounded,
                backgroundColor: Color(0x33171821),
                foregroundColor: Color(0xFFF6C56B),
                borderColor: Color(0x664A3422),
              ),
              const SizedBox(height: 18),
              Text(
                'Chef\'s tasting\nat ${restaurant.name}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                restaurant.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  _InfoPill(label: restaurant.priceTier, icon: Icons.sell_rounded),
                  const SizedBox(width: 10),
                  _InfoPill(
                    label: restaurant.availableSlots.first,
                    icon: Icons.schedule_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onReserve,
                child: const Text('Reserve this experience'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x22171821),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x334A3422)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: const Color(0xFFF6C56B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: const Color(0xFFF8F1E7)),
          ),
        ],
      ),
    );
  }
}
