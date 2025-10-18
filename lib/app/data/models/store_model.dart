class Store {
  final String? id;
  final String? storeId;
  final String? name;
  final String? description;
  final Address? address;
  final Location? location;
  final Contact? contact;
  final Map<String, OperatingHour>? operatingHours;
  final Amenities? amenities;
  final Rating? rating;
  final Pricing? pricing;
  final Features? features;
  final Verification? verification;
  final Metadata? metadata;
  final List<Service>? services;
  final List<String>? images;
  final bool? isActive;
  final String? fullAddress;
  final bool? isCurrentlyOpen;
  final int? serviceCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Store({
    this.id,
    this.storeId,
    this.name,
    this.description,
    this.address,
    this.location,
    this.contact,
    this.operatingHours,
    this.amenities,
    this.rating,
    this.pricing,
    this.features,
    this.verification,
    this.metadata,
    this.services,
    this.images,
    this.isActive,
    this.fullAddress,
    this.isCurrentlyOpen,
    this.serviceCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    Map<String, OperatingHour>? operatingHours;
    if (json['operatingHours'] != null) {
      operatingHours = {};
      // Handle both array and map formats
      if (json['operatingHours'] is List) {
        for (var item in json['operatingHours'] as List) {
          if (item is Map<String, dynamic> && item['day'] != null) {
            operatingHours[item['day']] = OperatingHour.fromJson(item);
          }
        }
      } else if (json['operatingHours'] is Map) {
        (json['operatingHours'] as Map<String, dynamic>).forEach((key, value) {
          operatingHours![key] = OperatingHour.fromJson(value);
        });
      }
    }

    return Store(
      id: json['id'] ?? json['_id'],
      storeId: json['storeId'],
      name: json['name'],
      description: json['description'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      contact: json['contact'] != null
          ? Contact.fromJson(json['contact'])
          : null,
      operatingHours: operatingHours,
      amenities: json['amenities'] != null
          ? Amenities.fromJson(json['amenities'])
          : null,
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
      pricing: json['pricing'] != null
          ? Pricing.fromJson(json['pricing'])
          : null,
      features: json['features'] != null
          ? Features.fromJson(json['features'])
          : null,
      verification: json['verification'] != null
          ? Verification.fromJson(json['verification'])
          : null,
      metadata: json['metadata'] != null
          ? Metadata.fromJson(json['metadata'])
          : null,
      services: json['services'] != null
          ? (json['services'] as List).map((e) => Service.fromJson(e)).toList()
          : null,
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      isActive: json['isActive'],
      fullAddress: json['fullAddress'],
      isCurrentlyOpen: json['isCurrentlyOpen'],
      serviceCount: json['serviceCount'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'description': description,
      'address': address?.toJson(),
      'location': location?.toJson(),
      'contact': contact?.toJson(),
      'operatingHours': operatingHours?.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'amenities': amenities?.toJson(),
      'rating': rating?.toJson(),
      'pricing': pricing?.toJson(),
      'features': features?.toJson(),
      'verification': verification?.toJson(),
      'metadata': metadata?.toJson(),
      'services': services?.map((e) => e.toJson()).toList(),
      'images': images,
      'isActive': isActive,
      'fullAddress': fullAddress,
      'isCurrentlyOpen': isCurrentlyOpen,
      'serviceCount': serviceCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Address {
  final String? street;
  final String? area;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;

  Address({
    this.street,
    this.area,
    this.city,
    this.state,
    this.postcode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      area: json['area'],
      city: json['city'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'area': area,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
    };
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}

class Contact {
  final String? phone;
  final String? email;
  final String? website;
  final String? whatsapp;

  Contact({this.phone, this.email, this.website, this.whatsapp});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      whatsapp: json['whatsapp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
      'whatsapp': whatsapp,
    };
  }
}

class OperatingHour {
  final bool? isOpen;
  final String? open;
  final String? close;

  OperatingHour({this.isOpen, this.open, this.close});

  factory OperatingHour.fromJson(Map<String, dynamic> json) {
    return OperatingHour(
      isOpen: json['isOpen'],
      open: json['open'],
      close: json['close'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'isOpen': isOpen, 'open': open, 'close': close};
  }
}

class Amenities {
  final List<String>? available;

  Amenities({this.available});

  factory Amenities.fromJson(Map<String, dynamic> json) {
    return Amenities(
      available: json['available'] != null
          ? List<String>.from(json['available'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'available': available};
  }
}

class Rating {
  final double? average;
  final int? count;

  Rating({this.average, this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(average: json['average']?.toDouble(), count: json['count']);
  }

  Map<String, dynamic> toJson() {
    return {'average': average, 'count': count};
  }
}

class Pricing {
  final PriceRange? range;
  final String? currency;

  Pricing({this.range, this.currency});

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      range: json['range'] != null ? PriceRange.fromJson(json['range']) : null,
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'range': range?.toJson(), 'currency': currency};
  }
}

class PriceRange {
  final double? min;
  final double? max;

  PriceRange({this.min, this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: json['min']?.toDouble(),
      max: json['max']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'min': min, 'max': max};
  }
}

class Features {
  final bool? hasParking;
  final bool? hasWifi;
  final bool? hasAircon;
  final bool? hasShower;
  final bool? isAccessible;

  Features({
    this.hasParking,
    this.hasWifi,
    this.hasAircon,
    this.hasShower,
    this.isAccessible,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      hasParking: json['hasParking'],
      hasWifi: json['hasWifi'],
      hasAircon: json['hasAircon'],
      hasShower: json['hasShower'],
      isAccessible: json['isAccessible'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasParking': hasParking,
      'hasWifi': hasWifi,
      'hasAircon': hasAircon,
      'hasShower': hasShower,
      'isAccessible': isAccessible,
    };
  }
}

class Verification {
  final bool? isVerified;
  final DateTime? verifiedAt;
  final String? verifiedBy;

  Verification({this.isVerified, this.verifiedAt, this.verifiedBy});

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      isVerified: json['isVerified'],
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'])
          : null,
      verifiedBy: json['verifiedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isVerified': isVerified,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'verifiedBy': verifiedBy,
    };
  }
}

class Metadata {
  final List<String>? tags;
  final String? category;
  final int? establishedYear;
  final String? licenseNumber;

  Metadata({
    this.tags,
    this.category,
    this.establishedYear,
    this.licenseNumber,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      category: json['category'],
      establishedYear: json['establishedYear'],
      licenseNumber: json['licenseNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags,
      'category': category,
      'establishedYear': establishedYear,
      'licenseNumber': licenseNumber,
    };
  }
}

class Service {
  final String? id;
  final String? name;
  final String? category;
  final Duration? duration;
  final ServicePricing? pricing;
  final double? pricePerMinute;
  final bool? hasDiscount;
  final int? discountPercentage;

  Service({
    this.id,
    this.name,
    this.category,
    this.duration,
    this.pricing,
    this.pricePerMinute,
    this.hasDiscount,
    this.discountPercentage,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      category: json['category'],
      duration: json['duration'] != null
          ? Duration.fromJson(json['duration'])
          : null,
      pricing: json['pricing'] != null
          ? ServicePricing.fromJson(json['pricing'])
          : null,
      pricePerMinute: json['pricePerMinute']?.toDouble(),
      hasDiscount: json['hasDiscount'],
      discountPercentage: json['discountPercentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'duration': duration?.toJson(),
      'pricing': pricing?.toJson(),
      'pricePerMinute': pricePerMinute,
      'hasDiscount': hasDiscount,
      'discountPercentage': discountPercentage,
    };
  }
}

class Duration {
  final int? minutes;
  final String? display;

  Duration({this.minutes, this.display});

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(minutes: json['minutes'], display: json['display']);
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
}

class StoresResponse {
  final String? message;
  final StoresData? data;

  StoresResponse({this.message, this.data});

  factory StoresResponse.fromJson(Map<String, dynamic> json) {
    return StoresResponse(
      message: json['message'],
      data: json['data'] != null ? StoresData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.toJson()};
  }
}

class StoresData {
  final List<Store>? stores;
  final Pagination? pagination;
  final Filters? filters;

  StoresData({this.stores, this.pagination, this.filters});

  factory StoresData.fromJson(Map<String, dynamic> json) {
    return StoresData(
      stores: json['stores'] != null
          ? (json['stores'] as List).map((e) => Store.fromJson(e)).toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      filters: json['filters'] != null
          ? Filters.fromJson(json['filters'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stores': stores?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
      'filters': filters?.toJson(),
    };
  }
}

class Pagination {
  final int? current;
  final int? total;
  final int? limit;
  final int? totalStores;

  Pagination({this.current, this.total, this.limit, this.totalStores});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      current: json['current'],
      total: json['total'],
      limit: json['limit'],
      totalStores: json['totalStores'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'total': total,
      'limit': limit,
      'totalStores': totalStores,
    };
  }
}

class Filters {
  final List<String>? availableCities;
  final List<String>? availableAmenities;

  Filters({this.availableCities, this.availableAmenities});

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      availableCities: json['availableCities'] != null
          ? List<String>.from(json['availableCities'])
          : null,
      availableAmenities: json['availableAmenities'] != null
          ? List<String>.from(json['availableAmenities'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableCities': availableCities,
      'availableAmenities': availableAmenities,
    };
  }
}
