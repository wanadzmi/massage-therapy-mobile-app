class Service {
  final String? id;
  final String? name;
  final String? description;
  final String? category;
  final ServiceDuration? duration;
  final ServicePricing? pricing;
  final List<String>? benefits;
  final List<String>? images;
  final bool? isActive;

  Service({
    this.id,
    this.name,
    this.description,
    this.category,
    this.duration,
    this.pricing,
    this.benefits,
    this.images,
    this.isActive,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      duration: json['duration'] != null
          ? ServiceDuration.fromJson(json['duration'])
          : null,
      pricing: json['pricing'] != null
          ? ServicePricing.fromJson(json['pricing'])
          : null,
      benefits: json['benefits'] != null
          ? List<String>.from(json['benefits'])
          : null,
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      isActive: json['isActive'] ?? json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category,
      'duration': duration?.toJson(),
      'pricing': pricing?.toJson(),
      'benefits': benefits,
      'images': images,
      'isActive': isActive,
    };
  }

  // Helper getters for backward compatibility
  double? get price => pricing?.price;
  int? get durationMinutes => duration?.minutes;
}

class ServiceDuration {
  final int? minutes;
  final String? display;

  ServiceDuration({this.minutes, this.display});

  factory ServiceDuration.fromJson(Map<String, dynamic> json) {
    return ServiceDuration(minutes: json['minutes'], display: json['display']);
  }

  Map<String, dynamic> toJson() {
    return {'minutes': minutes, 'display': display};
  }
}

class ServicePricing {
  final double? price;
  final String? currency;
  final double? discountPrice;

  ServicePricing({this.price, this.currency, this.discountPrice});

  factory ServicePricing.fromJson(Map<String, dynamic> json) {
    return ServicePricing(
      price: json['price']?.toDouble(),
      currency: json['currency'],
      discountPrice: json['discountPrice']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'currency': currency,
      'discountPrice': discountPrice,
    };
  }

  double get finalPrice => discountPrice ?? price ?? 0.0;
}
