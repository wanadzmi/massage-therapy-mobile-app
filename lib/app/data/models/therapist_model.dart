class Therapist {
  final String? id;
  final String? name;
  final String? profilePicture;
  final TherapistRating? rating;
  final int? experienceYears;
  final List<String>? specializations;
  final String? gender;
  final List<String>? languages;
  final TherapistStore? store;
  final List<String>? availableSlots;
  final double? price;
  final String? bio;
  final bool? isAvailable;

  Therapist({
    this.id,
    this.name,
    this.profilePicture,
    this.rating,
    this.experienceYears,
    this.specializations,
    this.gender,
    this.languages,
    this.store,
    this.availableSlots,
    this.price,
    this.bio,
    this.isAvailable,
  });

  // Convenience getters for view compatibility
  String? get profileImage => profilePicture;
  int? get experience => experienceYears;
  String? get specialization =>
      specializations?.isNotEmpty == true ? specializations!.first : null;

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      profilePicture: json['profilePicture'] ?? json['profileImage'],
      rating: json['rating'] != null
          ? TherapistRating.fromJson(json['rating'])
          : null,
      experienceYears: json['experienceYears'] ?? json['experience'],
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : null,
      gender: json['gender'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      store: json['store'] != null
          ? TherapistStore.fromJson(json['store'])
          : null,
      availableSlots: json['availableSlots'] != null
          ? List<String>.from(json['availableSlots'])
          : null,
      price: json['price']?.toDouble(),
      bio: json['bio'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profilePicture': profilePicture,
      'rating': rating?.toJson(),
      'experienceYears': experienceYears,
      'specializations': specializations,
      'gender': gender,
      'languages': languages,
      'store': store?.toJson(),
      'availableSlots': availableSlots,
      'price': price,
      'bio': bio,
      'isAvailable': isAvailable,
    };
  }
}

class TherapistRating {
  final double? average;
  final int? count;

  TherapistRating({this.average, this.count});

  factory TherapistRating.fromJson(Map<String, dynamic> json) {
    return TherapistRating(
      average: json['average']?.toDouble(),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'average': average, 'count': count};
  }
}

class TherapistStore {
  final String? id;
  final String? name;

  TherapistStore({this.id, this.name});

  factory TherapistStore.fromJson(Map<String, dynamic> json) {
    return TherapistStore(id: json['_id'] ?? json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
