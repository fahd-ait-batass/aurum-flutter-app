import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class ReservationConfirmationScreen extends StatelessWidget {
  const ReservationConfirmationScreen({
    super.key,
    required this.reservation,
    required this.restaurant,
  });

  final Reservation reservation;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservation confirmed')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: <Widget>[
          FeedbackStateCard(
            icon: Icons.event_available_rounded,
            title: 'Table confirmed at ${restaurant.name}',
            message:
                '${AppFormatters.reservationDate(reservation.date)} at ${reservation.timeLabel} for ${reservation.partySize} guests.',
          ),
          const SizedBox(height: 28),
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  reservation.guestName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  reservation.guestEmail,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (reservation.specialRequest.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  Text(
                    reservation.specialRequest,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
