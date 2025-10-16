class Service {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final int? duration; // in minutes
  final String? category;
  final String? imageUrl;
  final bool? isActive;

  Service({
    this.id,
    this.name,
    this.description,
    this.price,
    this.duration,
    this.category,
    this.imageUrl,
    this.isActive,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
      duration: json['duration'],
      category: json['category'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'category': category,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}
