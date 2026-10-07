class Sneaker {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String image;
  final List<String> galleryImages;
  final List<String> angleLabels;
  final Map<String, String> specs;
  final String description;
  final List<int> sizes;
  final bool isTrending;

  const Sneaker({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.galleryImages,
    this.angleLabels = const ['Dynamic 3/4', 'Lateral Side', 'Top Down', 'Heel / Back'],
    this.specs = const {
      'Colorway': 'Original / Retro',
      'Material': 'Full-Grain Leather',
      'Cushioning': 'Air-Sole Unit',
      'Outsole': 'Solid Rubber Traction',
    },
    required this.description,
    required this.sizes,
    this.isTrending = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'image': image,
      'galleryImages': galleryImages,
      'angleLabels': angleLabels,
      'specs': specs,
      'description': description,
      'sizes': sizes,
      'isTrending': isTrending,
    };
  }

  factory Sneaker.fromMap(Map<String, dynamic> map, [String? docId]) {
    return Sneaker(
      id: docId ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? 'Unnamed Sneaker',
      brand: map['brand'] as String? ?? 'Generic',
      category: map['category'] as String? ?? 'Lifestyle',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      image: map['image'] as String? ?? '',
      galleryImages: map['galleryImages'] != null
          ? List<String>.from(map['galleryImages'])
          : (map['image'] != null ? [map['image'] as String] : const []),
      angleLabels: map['angleLabels'] != null
          ? List<String>.from(map['angleLabels'])
          : const ['Dynamic 3/4', 'Lateral Side', 'Top Down', 'Heel / Back'],
      specs: map['specs'] != null
          ? Map<String, String>.from(map['specs'])
          : const {
              'Colorway': 'Original / Retro',
              'Material': 'Full-Grain Leather',
              'Cushioning': 'Air-Sole Unit',
              'Outsole': 'Solid Rubber Traction',
            },
      description: map['description'] as String? ?? '',
      sizes: map['sizes'] != null
          ? (map['sizes'] as List).map((e) => (e as num).toInt()).toList()
          : const [7, 8, 9, 10, 11],
      isTrending: map['isTrending'] as bool? ?? false,
    );
  }
}
