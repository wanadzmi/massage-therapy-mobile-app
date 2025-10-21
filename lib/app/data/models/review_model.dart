class Review {
  final String? id;
  final String? reviewId;
  final String? bookingId;
  final User? user;
  final Therapist? therapist;
  final Store? store;
  final Service? service;
  final Booking? booking;
  final ReviewRatings? ratings;
  final ReviewContent? review;
  final List<ReviewPhoto>? photos;
  final List<String>? tags;
  final String? status;
  final bool? isVerified;
  final HelpfulInfo? helpful;
  final ReviewResponse? response;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    this.id,
    this.reviewId,
    this.bookingId,
    this.user,
    this.therapist,
    this.store,
    this.service,
    this.booking,
    this.ratings,
    this.review,
    this.photos,
    this.tags,
    this.status,
    this.isVerified,
    this.helpful,
    this.response,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? json['id'],
      reviewId: json['reviewId'],
      bookingId: json['bookingId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      therapist: json['therapist'] != null
          ? Therapist.fromJson(json['therapist'])
          : null,
      store: json['store'] != null ? Store.fromJson(json['store']) : null,
      service: json['service'] != null
          ? Service.fromJson(json['service'])
          : null,
      booking: json['booking'] != null
          ? Booking.fromJson(json['booking'])
          : null,
      ratings: json['ratings'] != null
          ? ReviewRatings.fromJson(json['ratings'])
          : null,
      review: json['review'] != null
          ? ReviewContent.fromJson(json['review'])
          : null,
      photos: json['photos'] != null
          ? (json['photos'] as List)
                .map((p) => ReviewPhoto.fromJson(p))
                .toList()
          : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      status: json['status'],
      isVerified: json['isVerified'],
      helpful: json['helpful'] != null
          ? HelpfulInfo.fromJson(json['helpful'])
          : null,
      response: json['response'] != null
          ? ReviewResponse.fromJson(json['response'])
          : null,
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
      if (id != null) '_id': id,
      if (reviewId != null) 'reviewId': reviewId,
      if (bookingId != null) 'bookingId': bookingId,
      if (user != null) 'user': user!.toJson(),
      if (therapist != null) 'therapist': therapist!.toJson(),
      if (store != null) 'store': store!.toJson(),
      if (service != null) 'service': service!.toJson(),
      if (booking != null) 'booking': booking!.toJson(),
      if (ratings != null) 'ratings': ratings!.toJson(),
      if (review != null) 'review': review!.toJson(),
      if (photos != null) 'photos': photos!.map((p) => p.toJson()).toList(),
      if (tags != null) 'tags': tags,
      if (status != null) 'status': status,
      if (isVerified != null) 'isVerified': isVerified,
      if (helpful != null) 'helpful': helpful!.toJson(),
      if (response != null) 'response': response!.toJson(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class ReviewRatings {
  final int? overall;
  final int? technique;
  final int? professionalism;
  final int? cleanliness;
  final int? comfort;
  final int? valueForMoney;

  ReviewRatings({
    this.overall,
    this.technique,
    this.professionalism,
    this.cleanliness,
    this.comfort,
    this.valueForMoney,
  });

  factory ReviewRatings.fromJson(Map<String, dynamic> json) {
    return ReviewRatings(
      overall: json['overall'],
      technique: json['technique'],
      professionalism: json['professionalism'],
      cleanliness: json['cleanliness'],
      comfort: json['comfort'],
      valueForMoney: json['valueForMoney'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (overall != null) 'overall': overall,
      if (technique != null) 'technique': technique,
      if (professionalism != null) 'professionalism': professionalism,
      if (cleanliness != null) 'cleanliness': cleanliness,
      if (comfort != null) 'comfort': comfort,
      if (valueForMoney != null) 'valueForMoney': valueForMoney,
    };
  }

  double get average {
    int count = 0;
    int sum = 0;
    if (overall != null) {
      sum += overall!;
      count++;
    }
    if (technique != null) {
      sum += technique!;
      count++;
    }
    if (professionalism != null) {
      sum += professionalism!;
      count++;
    }
    if (cleanliness != null) {
      sum += cleanliness!;
      count++;
    }
    if (comfort != null) {
      sum += comfort!;
      count++;
    }
    if (valueForMoney != null) {
      sum += valueForMoney!;
      count++;
    }
    return count > 0 ? sum / count : 0;
  }
}

class ReviewContent {
  final String? title;
  final String? content;
  final List<String>? pros;
  final List<String>? cons;

  ReviewContent({this.title, this.content, this.pros, this.cons});

  factory ReviewContent.fromJson(Map<String, dynamic> json) {
    return ReviewContent(
      title: json['title'],
      content: json['content'],
      pros: json['pros'] != null ? List<String>.from(json['pros']) : null,
      cons: json['cons'] != null ? List<String>.from(json['cons']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (pros != null) 'pros': pros,
      if (cons != null) 'cons': cons,
    };
  }
}

class ReviewPhoto {
  final String? url;
  final String? caption;

  ReviewPhoto({this.url, this.caption});

  factory ReviewPhoto.fromJson(Map<String, dynamic> json) {
    return ReviewPhoto(url: json['url'], caption: json['caption']);
  }

  Map<String, dynamic> toJson() {
    return {
      if (url != null) 'url': url,
      if (caption != null) 'caption': caption,
    };
  }
}

class HelpfulInfo {
  final int? count;
  final List<String>? users;

  HelpfulInfo({this.count, this.users});

  factory HelpfulInfo.fromJson(Map<String, dynamic> json) {
    return HelpfulInfo(
      count: json['count'],
      users: json['users'] != null ? List<String>.from(json['users']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (count != null) 'count': count,
      if (users != null) 'users': users,
    };
  }
}

class ReviewResponse {
  final String? content;
  final RespondedBy? respondedBy;
  final DateTime? respondedAt;

  ReviewResponse({this.content, this.respondedBy, this.respondedAt});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      content: json['content'],
      respondedBy: json['respondedBy'] != null
          ? RespondedBy.fromJson(json['respondedBy'])
          : null,
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (content != null) 'content': content,
      if (respondedBy != null) 'respondedBy': respondedBy!.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt!.toIso8601String(),
    };
  }
}

class RespondedBy {
  final String? name;

  RespondedBy({this.name});

  factory RespondedBy.fromJson(Map<String, dynamic> json) {
    return RespondedBy(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {if (name != null) 'name': name};
  }
}

// Simplified nested models (reusing from existing models)
class User {
  final String? id;
  final String? name;
  final String? memberTier;

  User({this.id, this.name, this.memberTier});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      memberTier: json['memberTier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (memberTier != null) 'memberTier': memberTier,
    };
  }
}

class Therapist {
  final String? id;
  final String? name;
  final String? profileImage;

  Therapist({this.id, this.name, this.profileImage});

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}

class Store {
  final String? id;
  final String? name;
  final String? address;

  Store({this.id, this.name, this.address});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
    };
  }
}

class Service {
  final String? id;
  final String? name;
  final int? duration;

  Service({this.id, this.name, this.duration});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (duration != null) 'duration': duration,
    };
  }
}

class Booking {
  final String? date;
  final String? startTime;

  Booking({this.date, this.startTime});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(date: json['date'], startTime: json['startTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      if (date != null) 'date': date,
      if (startTime != null) 'startTime': startTime,
    };
  }
}
