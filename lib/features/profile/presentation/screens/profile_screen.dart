import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/features/profile/data/profile_seed_data.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';
import 'package:flutter_app/shared/widgets/remote_sync_status_card.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final Reservation? upcomingReservation = appState.upcomingReservation;
    final List<Reservation> reservationHistory = appState.reservationHistory
        .take(3)
        .toList(growable: false);
    final List<OrderReceipt> orderHistory = appState.orderHistory
        .take(3)
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: <Widget>[
        SurfaceCard(
          radius: 32,
          padding: const EdgeInsets.all(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF1B202A), Color(0xFF11141B)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFFF6C56B), Color(0xFFE0843D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        appState.userProfile.initials,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF221507),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          appState.userProfile.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appState.userProfile.email,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appState.userProfile.bio,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  StatusChip(
                    label: appState.userProfile.membershipTier,
                    icon: Icons.workspace_premium_rounded,
                    backgroundColor: const Color(0xFF241B12),
                    foregroundColor: const Color(0xFFF6C56B),
                    borderColor: const Color(0xFF4A3320),
                  ),
                  StatusChip(
                    label: '${appState.userProfile.points} points',
                    icon: Icons.stars_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _ProfileStat(
                      value: '${appState.reservationCount}',
                      label: 'Reservations',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ProfileStat(
                      value: '${appState.orderCount}',
                      label: 'Orders',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ProfileStat(
                      value: '${appState.favoriteCount}',
                      label: 'Favorites',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: appState.signOut,
                child: const Text('Sign out on this device'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        RemoteSyncStatusCard(
          status: appState.remoteSyncStatus,
          onRetry: appState.retryRemoteSync,
        ),
        const SizedBox(height: 28),
        if (upcomingReservation != null)
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const StatusChip(
                  label: 'Next reservation',
                  icon: Icons.event_available_rounded,
                ),
                const SizedBox(height: 16),
                Text(
                  appState.restaurantById(upcomingReservation.restaurantId).name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppFormatters.reservationDate(upcomingReservation.date)} | ${upcomingReservation.timeLabel}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  '${upcomingReservation.partySize} guests | ${upcomingReservation.experienceLabel}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => AppNavigator.showReservation(
                    context,
                    restaurantId: upcomingReservation.restaurantId,
                  ),
                  child: const Text('Manage booking'),
                ),
              ],
            ),
          )
        else
          const FeedbackStateCard(
            icon: Icons.event_busy_rounded,
            title: 'No upcoming reservation',
            message:
                'Your next confirmed table will appear here with guest details and timing.',
          ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Reservation history',
          subtitle: 'Your latest tables, confirmations, and completed evenings.',
        ),
        const SizedBox(height: 14),
        if (reservationHistory.isEmpty)
          const FeedbackStateCard(
            icon: Icons.event_note_rounded,
            title: 'No reservation history yet',
            message:
                'Book a table and your past and upcoming reservations will stay visible here.',
          )
        else
          ...reservationHistory.map(
            (Reservation reservation) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ReservationHistoryTile(reservation: reservation),
            ),
          ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Order history',
          subtitle: 'Recent deliveries and completed orders stored on this device.',
        ),
        const SizedBox(height: 14),
        if (orderHistory.isEmpty)
          const FeedbackStateCard(
            icon: Icons.receipt_long_rounded,
            title: 'No order history yet',
            message:
                'Place an order and it will stay available here along with its total and reference.',
          )
        else
          ...orderHistory.map(
            (OrderReceipt order) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OrderHistoryTile(order: order),
            ),
          ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Account',
          subtitle: 'Premium controls, dining preferences, and saved details.',
        ),
        const SizedBox(height: 14),
        ...accountShortcuts.map(
          (AccountShortcut item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AccountShortcutTile(
              item: item,
              onTap: () => _handleShortcut(context, item),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleShortcut(BuildContext context, AccountShortcut item) {
    switch (item.target) {
      case AccountShortcutTarget.cart:
        return AppNavigator.showCart(context);
      case AccountShortcutTarget.favorites:
        return AppNavigator.showFavorites(context);
      case AccountShortcutTarget.reservation:
        return AppNavigator.showReservation(
          context,
          restaurantId: item.restaurantId ?? 'aurum_lounge',
        );
      case AccountShortcutTarget.featuredRestaurant:
        return AppNavigator.showRestaurantDetails(
          context,
          restaurantId: item.restaurantId ?? 'aurum_lounge',
        );
    }
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF151821),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A303A)),
      ),
      child: Column(
        children: <Widget>[
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ReservationHistoryTile extends StatelessWidget {
  const _ReservationHistoryTile({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final String restaurantName = appState
        .restaurantById(reservation.restaurantId)
        .name;

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  restaurantName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusChip(
                label: reservation.statusLabel,
                icon: reservation.statusLabel == 'Completed'
                    ? Icons.check_circle_outline_rounded
                    : Icons.event_available_rounded,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${AppFormatters.reservationDate(reservation.date)} | ${reservation.timeLabel}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            '${reservation.partySize} guests | ${reservation.guestName}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  const _OrderHistoryTile({required this.order});

  final OrderReceipt order;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  order.reference,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusChip(
                label: order.statusLabel,
                icon: Icons.local_shipping_outlined,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${order.itemsCount} items | ${AppFormatters.currencyMad(order.totalMad)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            '${AppFormatters.compactDate(order.placedAt)} | ${order.fulfillmentLabel}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AccountShortcutTile extends StatelessWidget {
  const _AccountShortcutTile({required this.item, required this.onTap});

  final AccountShortcut item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(item.icon, color: item.accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF908A82)),
        ],
      ),
    );
  }
}
