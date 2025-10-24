class BannerModel {
  final String id;
  final String title;
  final String? description;
  final String image;
  final String type;
  final BannerLink? link;
  final int position;
  final DateTime? startDate;
  final DateTime? endDate;

  BannerModel({
    required this.id,
    required this.title,
    this.description,
    required this.image,
    required this.type,
    this.link,
    required this.position,
    this.startDate,
    this.endDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      image: json['image'] as String,
      type: json['type'] as String,
      link: json['link'] != null
          ? BannerLink.fromJson(json['link'] as Map<String, dynamic>)
          : null,
      position: json['position'] as int? ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'type': type,
      'link': link?.toJson(),
      'position': position,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

class BannerLink {
  final String type; // 'internal', 'external', 'none'
  final String? url;
  final String? target; // 'service', 'store', 'voucher', 'booking', 'other'
  final String? targetId;

  BannerLink({required this.type, this.url, this.target, this.targetId});

  factory BannerLink.fromJson(Map<String, dynamic> json) {
    return BannerLink(
      type: json['type'] as String,
      url: json['url'] as String?,
      target: json['target'] as String?,
      targetId: json['targetId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'url': url, 'target': target, 'targetId': targetId};
  }
}
