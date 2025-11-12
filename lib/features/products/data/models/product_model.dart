import 'package:hive/hive.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

/// Product model for data layer with JSON serialization and Hive persistence
@HiveType(typeId: 0)
class ProductModel extends Product {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final RatingModel? rating;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  }) : super(
         id: id,
         title: title,
         price: price,
         description: description,
         category: category,
         image: image,
         rating: rating,
       );

  /// Create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating?.toJson(),
    };
  }

  /// Create ProductModel from Product entity
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      image: product.image,
      rating: product.rating != null
          ? RatingModel.fromEntity(product.rating!)
          : null,
    );
  }
}

/// Rating model for data layer with JSON serialization and Hive persistence
@HiveType(typeId: 1)
class RatingModel extends Rating {
  @HiveField(0)
  final double rate;

  @HiveField(1)
  final int count;

  const RatingModel({required this.rate, required this.count})
    : super(rate: rate, count: count);

  /// Create RatingModel from JSON
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  /// Convert RatingModel to JSON
  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }

  /// Create RatingModel from Rating entity
  factory RatingModel.fromEntity(Rating rating) {
    return RatingModel(rate: rating.rate, count: rating.count);
  }
}
