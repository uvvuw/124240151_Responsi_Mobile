class Rating {
  final int rate;
  final String count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> j) {
    return Rating(
      rate: (j['rate'] as num?)?.toInt() ?? 0,
      count: j['count'] ?? '0',
    );
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rate;
  final List<String> image;
  final String count;
  final List<Rating> rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rate,
    required this.count,
    this.image = const [],
    this.rating = const [],
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    final imgs =
        (j['image'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    return Product(
      id: j['id'],
      title: j['title'] ?? '',
      description: j['description'] ?? '',
      category: j['category'] ?? '',
      price: (j['price'] as num).toDouble(),
      rate: (j['rate'] as num?)?.toDouble() ?? 0,
      count: j['count']?.toString() ?? '0',
      image: imgs,
      rating:
          (j['rating'] as List?)
              ?.map((e) => Rating.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}
