class Rating {
  final double rate;
  final int count;

  const Rating({required this.rate, required this.count});
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  // Dari response FakeStoreAPI
  factory Product.fromJson(Map<String, dynamic> j) {
    final r = j['rating'] as Map<String, dynamic>?;
    return Product(
      id: (j['id'] as num).toInt(),
      title: j['title'] ?? '',
      price: (j['price'] as num).toDouble(),
      description: j['description'] ?? '',
      category: j['category'] ?? '',
      image: j['image'] ?? '',
      rating: Rating(
        rate: (r?['rate'] as num?)?.toDouble() ?? 0,
        count: (r?['count'] as num?)?.toInt() ?? 0,
      ),
    );
  }

  // Untuk disimpan ke Hive
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
    'rate': rating.rate,
    'count': rating.count,
  };

  factory Product.fromMap(Map<String, dynamic> m) => Product(
    id: m['id'] as int,
    title: m['title'] as String,
    price: (m['price'] as num).toDouble(),
    description: m['description'] as String,
    category: m['category'] as String,
    image: m['image'] as String,
    rating: Rating(
      rate: (m['rate'] as num).toDouble(),
      count: (m['count'] as num).toInt(),
    ),
  );
}