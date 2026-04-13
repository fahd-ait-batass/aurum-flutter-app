import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _requestController;
  int _selectedDateIndex = 0;
  int _partySize = 2;
  String? _selectedSlot;
  List<DateTime> _candidateDates() {
    final DateTime today = DateTime.now();
    return List<DateTime>.generate(
      4,
      (int index) => DateTime(today.year, today.month, today.day + index),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _requestController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = RestaurantAppScope.read(context);
    if (_nameController.text.isEmpty) {
      _nameController.text = appState.userProfile.name;
    }
    if (_emailController.text.isEmpty) {
      _emailController.text = appState.userProfile.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final Restaurant restaurant = appState.restaurantById(widget.restaurantId);
    final List<DateTime> dates = _candidateDates();
    _selectedSlot ??= restaurant.availableSlots.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Reservation')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: <Widget>[
          SurfaceCard(
            radius: 32,
            padding: const EdgeInsets.all(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: restaurant.gradientColors,
            ),
            borderColor: const Color(0xFF4A3422),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const StatusChip(
                  label: 'Reserve tonight',
                  icon: Icons.event_seat_rounded,
                  backgroundColor: Color(0x29151821),
                  foregroundColor: Color(0xFFF6C56B),
                  borderColor: Color(0x554A3422),
                ),
                const SizedBox(height: 18),
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${restaurant.cuisine} | ${restaurant.neighborhood}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFFF6C56B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  restaurant.moodLine,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Guest details',
            subtitle: 'Use the same name and email the dining room should recognize.',
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Guest name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (String? value) {
                      final String text = value?.trim() ?? '';
                      if (text.length < 2) {
                        return 'Enter the guest name for the reservation.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Reservation email',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                    validator: (String? value) {
                      final String email = value?.trim() ?? '';
                      final RegExp emailPattern = RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      );
                      if (!emailPattern.hasMatch(email)) {
                        return 'Enter a valid reservation email.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _requestController,
                    maxLines: 3,
                    maxLength: 120,
                    decoration: const InputDecoration(
                      labelText: 'Special request',
                      prefixIcon: Icon(Icons.edit_note_rounded),
                      hintText: 'Window table, allergy note, celebration, or pacing request',
                    ),
                    validator: (String? value) {
                      final String text = value?.trim() ?? '';
                      if (text.length > 120) {
                        return 'Keep the note under 120 characters.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Choose your date',
            subtitle:
                'Prime tables and chef counters available across the next four evenings.',
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(dates.length, (int index) {
                final bool isSelected = index == _selectedDateIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _SelectablePill(
                    label: AppFormatters.compactDate(dates[index]),
                    selected: isSelected,
                    onTap: () => setState(() => _selectedDateIndex = index),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Choose your time',
            subtitle: 'Curated seatings still available right now.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: restaurant.availableSlots.map((String slot) {
              final bool isSelected = slot == _selectedSlot;
              return _SelectablePill(
                label: slot,
                selected: isSelected,
                onTap: () => setState(() => _selectedSlot = slot),
              );
            }).toList(growable: false),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Party size',
            subtitle: 'Adjust the booking for your guests.',
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: _partySize > 1
                      ? () => setState(() => _partySize -= 1)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_partySize guests',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _partySize < 10
                      ? () => setState(() => _partySize += 1)
                      : null,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Reservation summary',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                _SummaryRow(
                  label: 'Date',
                  value: AppFormatters.reservationDate(dates[_selectedDateIndex]),
                ),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Time', value: _selectedSlot!),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Guests', value: '$_partySize'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              final Reservation reservation = appState.createReservation(
                restaurantId: restaurant.id,
                date: dates[_selectedDateIndex],
                timeLabel: _selectedSlot!,
                partySize: _partySize,
                guestName: _nameController.text.trim(),
                guestEmail: _emailController.text.trim(),
                specialRequest: _requestController.text.trim(),
                experienceLabel: restaurant.badgeLabel,
              );
              AppNavigator.showReservationConfirmation(
                context,
                reservation: reservation,
                restaurant: restaurant,
              );
            },
            child: const Text('Confirm reservation'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 86,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class _SelectablePill extends StatelessWidget {
  const _SelectablePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0x29F6B756) : const Color(0xFF171B23),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0x55F6B756) : const Color(0xFF2B313C),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? const Color(0xFFF6C56B) : const Color(0xFFE8E0D5),
          ),
        ),
      ),
    );
  }
}
