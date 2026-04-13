class Reservation {
  const Reservation({
    required this.id,
    required this.restaurantId,
    required this.date,
    required this.createdAt,
    required this.timeLabel,
    required this.partySize,
    required this.experienceLabel,
    required this.statusLabel,
    required this.guestName,
    required this.guestEmail,
    this.specialRequest = '',
  });

  final String id;
  final String restaurantId;
  final DateTime date;
  final DateTime createdAt;
  final String timeLabel;
  final int partySize;
  final String experienceLabel;
  final String statusLabel;
  final String guestName;
  final String guestEmail;
  final String specialRequest;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'restaurantId': restaurantId,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'timeLabel': timeLabel,
      'partySize': partySize,
      'experienceLabel': experienceLabel,
      'statusLabel': statusLabel,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'specialRequest': specialRequest,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      timeLabel: json['timeLabel'] as String,
      partySize: json['partySize'] as int,
      experienceLabel: json['experienceLabel'] as String,
      statusLabel: json['statusLabel'] as String,
      guestName: json['guestName'] as String? ?? '',
      guestEmail: json['guestEmail'] as String? ?? '',
      specialRequest: json['specialRequest'] as String? ?? '',
    );
  }
}
