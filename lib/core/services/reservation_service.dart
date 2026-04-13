import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/services/auth_service.dart';

class ReservationMutationResult {
  const ReservationMutationResult({
    required this.session,
    required this.reservation,
  });

  final AppSessionState session;
  final Reservation reservation;
}

class ReservationService {
  const ReservationService({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;

  ReservationMutationResult createReservation(
    AppSessionState session, {
    required Restaurant restaurant,
    required DateTime date,
    required String timeLabel,
    required int partySize,
    required String guestName,
    required String guestEmail,
    String? specialRequest,
    String? experienceLabel,
  }) {
    final Reservation reservation = Reservation(
      id: 'resv-${session.reservations.length + 101}',
      restaurantId: restaurant.id,
      date: date,
      createdAt: DateTime.now(),
      timeLabel: timeLabel,
      partySize: partySize,
      experienceLabel:
          experienceLabel ?? '${restaurant.cuisine} table experience',
      statusLabel: 'Confirmed',
      guestName: guestName,
      guestEmail: guestEmail,
      specialRequest: specialRequest ?? '',
    );

    final List<Reservation> reservations = List<Reservation>.from(
      session.reservations,
    )..add(reservation);
    final updatedSession = session.copyWith(
      reservations: reservations,
      userProfile: session.userProfile.copyWith(
        name: guestName,
        email: guestEmail,
        initials: _authService.buildInitials(guestName),
        points: session.userProfile.points + 40,
      ),
    );

    return ReservationMutationResult(
      session: updatedSession,
      reservation: reservation,
    );
  }
}
