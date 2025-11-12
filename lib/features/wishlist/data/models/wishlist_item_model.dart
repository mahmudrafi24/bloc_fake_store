import 'package:hive/hive.dart';
import '../../../products/data/models/product_model.dart';
import '../../domain/entities/wishlist_item.dart';

part 'wishlist_item_model.g.dart';

/// WishlistItem model for data layer with JSON serialization and Hive persistence
@HiveType(typeId: 3)
class WishlistItemModel extends WishlistItem {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  final ProductModel product;

  @HiveField(2)
  @override
  final DateTime addedAt;

  const WishlistItemModel({
    required this.id,
    required this.product,
    required this.addedAt,
  }) : super(id: id, product: product, addedAt: addedAt);

  /// Create WishlistItemModel from JSON
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  /// Convert WishlistItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create WishlistItemModel from WishlistItem entity
  factory WishlistItemModel.fromEntity(WishlistItem wishlistItem) {
    return WishlistItemModel(
      id: wishlistItem.id,
      product: ProductModel.fromEntity(wishlistItem.product),
      addedAt: wishlistItem.addedAt,
    );
  }

  /// Create a copy with updated fields
  WishlistItemModel copyWith({
    int? id,
    ProductModel? product,
    DateTime? addedAt,
  }) {
    return WishlistItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
