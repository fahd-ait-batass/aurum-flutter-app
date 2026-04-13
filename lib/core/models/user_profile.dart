class UserProfile {
  const UserProfile({
    required this.name,
    required this.initials,
    required this.email,
    required this.city,
    required this.membershipTier,
    required this.points,
    required this.bio,
  });

  final String name;
  final String initials;
  final String email;
  final String city;
  final String membershipTier;
  final int points;
  final String bio;

  UserProfile copyWith({
    String? name,
    String? initials,
    String? email,
    String? city,
    String? membershipTier,
    int? points,
    String? bio,
  }) {
    return UserProfile(
      name: name ?? this.name,
      initials: initials ?? this.initials,
      email: email ?? this.email,
      city: city ?? this.city,
      membershipTier: membershipTier ?? this.membershipTier,
      points: points ?? this.points,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'initials': initials,
      'email': email,
      'city': city,
      'membershipTier': membershipTier,
      'points': points,
      'bio': bio,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      initials: json['initials'] as String,
      email: json['email'] as String? ?? '',
      city: json['city'] as String,
      membershipTier: json['membershipTier'] as String,
      points: json['points'] as int,
      bio: json['bio'] as String,
    );
  }
}
