class GeneralModel {
  final List<CarouselImage> homeCarouselImages;
  final List<CarouselImage> subscriptionCarouselImages;
  final List<OfferTagline> offerTaglines;
  final List<Breed> catBreeds;
  final List<Breed> dogBreeds;

  GeneralModel({
    required this.homeCarouselImages,
    required this.subscriptionCarouselImages,
    required this.offerTaglines,
    required this.catBreeds,
    required this.dogBreeds,
  });

  factory GeneralModel.fromJson(Map<String, dynamic> json) {
    return GeneralModel(
      homeCarouselImages: (json['home_carousel_images'] as List)
          .map((e) => CarouselImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      subscriptionCarouselImages: (json['subscription_carousel_images'] as List)
          .map((e) => CarouselImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      offerTaglines: (json['offer_taglines'] as List)
          .map((e) => OfferTagline.fromJson(e as Map<String, dynamic>))
          .toList(),
      catBreeds: (json['cat_breeds'] as List)
          .map((e) => Breed.fromJson(e as Map<String, dynamic>))
          .toList(),
      dogBreeds: (json['dog_breeds'] as List)
          .map((e) => Breed.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'home_carousel_images':
            homeCarouselImages.map((e) => e.toJson()).toList(),
        'subscription_carousel_images':
            subscriptionCarouselImages.map((e) => e.toJson()).toList(),
        'offer_taglines': offerTaglines.map((e) => e.toJson()).toList(),
        'cat_breeds': catBreeds.map((e) => e.toJson()).toList(),
        'dog_breeds': dogBreeds.map((e) => e.toJson()).toList(),
      };
}

class CarouselImage {
  final String id;
  final String page;
  final String imageUrl;
  final String s3Url;

  CarouselImage({
    required this.id,
    required this.page,
    required this.imageUrl,
    required this.s3Url,
  });

  factory CarouselImage.fromJson(Map<String, dynamic> json) => CarouselImage(
        id: json['id'] as String,
        page: json['page'] as String,
        imageUrl: json['image_url'] as String,
        s3Url: json['s3_url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'page': page,
        'image_url': imageUrl,
        's3_url': s3Url,
      };
}

class OfferTagline {
  final String id;
  final String tagline;

  OfferTagline({
    required this.id,
    required this.tagline,
  });

  factory OfferTagline.fromJson(Map<String, dynamic> json) => OfferTagline(
        id: json['id'] as String,
        tagline: json['tagline'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tagline': tagline,
      };
}

class Breed {
  final String id;
  final String name;
  final String imageUrl;
  final String? s3Url;

  Breed({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.s3Url,
  });

  factory Breed.fromJson(Map<String, dynamic> json) => Breed(
        id: json['id'] as String,
        name: json['name'] as String,
        imageUrl: json['image_url'] as String,
        s3Url: json['s3_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        's3_url': s3Url,
      };
}
